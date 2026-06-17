set -euo pipefail

usage() {
  cat <<'USAGE'
Usage: restore-container <container> <container_path> [snapshot_id] [service]

Restore a container's data directory from the local restic backup.

Arguments:
  container       Container name (e.g., meal, uptime-kuma)
  container_path  Path inside the container to restore to
                  (e.g., /var/lib/private/mealie)
  snapshot_id     Optional: specific snapshot to restore. Defaults to latest.
  service         Optional: systemd service to stop/start. Defaults to
                  last component of container_path.

Examples:
  sudo restore-container meal /var/lib/private/mealie
  sudo restore-container meal /var/lib/private/mealie abc12345
  sudo restore-container uptime-kuma /var/lib/private/uptime-kuma
USAGE
}

if [ "$(id -u)" -ne 0 ]; then
  echo "error: this script must be run as root (use sudo)" >&2
  exit 1
fi

if [ $# -lt 2 ]; then
  usage
  exit 1
fi

CONTAINER="$1"
CONTAINER_PATH="$2"
SNAPSHOT="${3:-latest}"
SERVICE="${4:-$(basename "$CONTAINER_PATH")}"
RESTIC_REPO="/backup/backups/"
PASSWORD_FILE="/run/agenix/restic-password"
BACKUP_FOLDER_NAME="$(basename "$CONTAINER_PATH")"
TARBALL="/tmp/restore-${CONTAINER}.tar"

NIXOS_CONTAINER="@nixos_container@/bin/nixos-container"

echo "=== Restore container data: $CONTAINER ==="
echo "  Target path: $CONTAINER_PATH"
echo "  Snapshot:    $SNAPSHOT"
echo "  Service:     $SERVICE"
echo ""

# Mount backup drive if not mounted
if ! mountpoint -q /backup; then
  echo "Mounting backup drive..."
  mount /dev/disk/by-label/backup-drive /backup 2>/dev/null || {
    echo "error: could not mount /backup. Is the drive connected?" >&2
    exit 1
  }
fi

# Check restic repo exists
if ! test -d "$RESTIC_REPO"; then
  echo "error: restic repository not found at $RESTIC_REPO" >&2
  exit 1
fi

# Verify the password file exists
if ! test -f "$PASSWORD_FILE"; then
  echo "error: restic password file not found at $PASSWORD_FILE" >&2
  echo "Make sure the agenix secret is decrypted." >&2
  exit 1
fi

echo "Step 1: Finding snapshot..."
RESTIC_CMD="restic -r $RESTIC_REPO --password-file $PASSWORD_FILE"

if [ "$SNAPSHOT" = "latest" ]; then
  echo "  Looking for latest snapshot..."
  SNAPSHOT=$($RESTIC_CMD snapshots --latest 1 2>/dev/null \
    | grep -oP '^\s*\K[a-f0-9]{8,}' | head -1 || true)

  if [ -z "$SNAPSHOT" ]; then
    echo "error: no snapshots found" >&2
    echo "" >&2
    $RESTIC_CMD snapshots 2>&1 || true
    exit 1
  fi

  echo "  Latest snapshot: $SNAPSHOT"
fi

# Auto-detect the backup root path from the snapshot
# (the host user may differ from the dotfiles user, e.g. /home/g5/backups)
BACKUP_DIR=$($RESTIC_CMD ls "$SNAPSHOT" 2>/dev/null \
  | grep -oP '^/home/[^/]+/backups' | head -1 || true)

if [ -z "$BACKUP_DIR" ]; then
  echo "error: could not determine backup directory from snapshot $SNAPSHOT" >&2
  exit 1
fi

echo "  Backup root: $BACKUP_DIR"

# Verify the snapshot contains our data
echo ""
echo "  Checking snapshot $SNAPSHOT for $BACKUP_DIR/$BACKUP_FOLDER_NAME ..."
SNAPSHOT_PATHS=$($RESTIC_CMD ls "$SNAPSHOT" 2>/dev/null || true)
if ! echo "$SNAPSHOT_PATHS" | grep -q "$BACKUP_DIR/$BACKUP_FOLDER_NAME"; then
  echo "  Warning: snapshot $SNAPSHOT does not seem to contain $BACKUP_DIR/$BACKUP_FOLDER_NAME"
  echo "  Available paths in snapshot:"
  echo "$SNAPSHOT_PATHS" | grep "$BACKUP_DIR" | head -10 || echo "    (none found under $BACKUP_DIR)"
fi

echo ""
echo "Step 2: Stopping service and capturing user info..."
SERVICE_USER=""
if ! $NIXOS_CONTAINER run "$CONTAINER" -- \
  systemctl is-active "$SERVICE" >/dev/null 2>&1; then
  echo "  ✓ Service '$SERVICE' is not running — skip stop"
  # Get user from unit file even if not running
  SERVICE_USER=$($NIXOS_CONTAINER run "$CONTAINER" -- \
    bash -c "systemctl show -p User '$SERVICE' 2>/dev/null | sed 's/^User=//'" 2>/dev/null || true)
else
  SERVICE_USER=$($NIXOS_CONTAINER run "$CONTAINER" -- \
    bash -c "systemctl show -p User '$SERVICE' 2>/dev/null | sed 's/^User=//'" 2>/dev/null || true)
  echo "  → Stopping service '$SERVICE'..."
  $NIXOS_CONTAINER run "$CONTAINER" -- \
    systemctl stop "$SERVICE" 2>&1 | sed 's/^/  /'
  echo "  ✓ Service '$SERVICE' stopped"
fi
if [ -n "$SERVICE_USER" ]; then
  echo "  → Service user: $SERVICE_USER"
fi

echo ""
echo "Step 3: Restoring from restic backup..."
RESTORE_DIR=$(mktemp -d)
trap "rm -rf $RESTORE_DIR $TARBALL" EXIT

echo "  → Snapshot: $SNAPSHOT"
echo "  → Path:     $BACKUP_DIR/$BACKUP_FOLDER_NAME"
$RESTIC_CMD restore "$SNAPSHOT" --target "$RESTORE_DIR" \
  --path "$BACKUP_DIR" --include "${BACKUP_DIR}/${BACKUP_FOLDER_NAME}/**" 2>&1 | sed 's/^/  /'

# Count restored files
echo "  → Verifying restored data..."
RESTORED_FILE_COUNT=$(find "$RESTORE_DIR" -type f 2>/dev/null | wc -l)
RESTORED_SIZE=$(du -sh "$RESTORE_DIR" 2>/dev/null | cut -f1)
echo "  ✓ Restored $RESTORED_FILE_COUNT files ($RESTORED_SIZE)" 2>/dev/null || true

# Find the restored data
RESTORED_PATH="$RESTORE_DIR/$BACKUP_DIR/$BACKUP_FOLDER_NAME"
if [ ! -d "$RESTORED_PATH" ]; then
  RESTORED_PATH=$(find "$RESTORE_DIR" -maxdepth 5 -type d \
    -name "$BACKUP_FOLDER_NAME" 2>/dev/null | head -1)
fi

if [ -z "$RESTORED_PATH" ] || [ ! -d "$RESTORED_PATH" ]; then
  echo "error: could not find restored data" >&2
  echo "  Looked for: $RESTORE_DIR/$BACKUP_DIR/$BACKUP_FOLDER_NAME" >&2
  echo "  Contents of $RESTORE_DIR:" >&2
  find "$RESTORE_DIR" -maxdepth 5 -type d 2>/dev/null | head -20 >&2
  exit 1
fi

echo "  ✓ Data at: $RESTORED_PATH"
echo "  Contents:"
ls -la "$RESTORED_PATH" | sed 's/^/    /'

echo ""
echo "Step 4: Copying data into container..."
echo "  → Preparing target path in container..."
$NIXOS_CONTAINER run "$CONTAINER" -- \
  bash -c "rm -rf '$CONTAINER_PATH' && mkdir -p '$CONTAINER_PATH'" 2>&1 | sed 's/^/  /'

echo "  → Archiving and copying via tar + machinectl..."
tar cf "$TARBALL" -C "$RESTORED_PATH" . 2>&1 | sed 's/^/  /'

if machinectl copy-to "$CONTAINER" "$TARBALL" /tmp/restore.tar; then
  $NIXOS_CONTAINER run "$CONTAINER" -- \
    bash -c "cd '$CONTAINER_PATH' && tar xf /tmp/restore.tar && rm /tmp/restore.tar"
  rm -f "$TARBALL"
  echo "  ✓ Copy complete"
else
  echo "  ✗ machinectl copy-to failed" >&2
  rm -f "$TARBALL"
  exit 1
fi

echo "  → Cleaning stale WAL/SHM files..."
$NIXOS_CONTAINER run "$CONTAINER" -- \
  bash -c "rm -f '$CONTAINER_PATH'/*.db-wal '$CONTAINER_PATH'/*.db-shm" 2>&1 | sed 's/^/  /'

echo ""
echo "Step 5: Fixing permissions..."
if [ -n "$SERVICE_USER" ]; then
  # Check if user exists in container before chown
  if $NIXOS_CONTAINER run "$CONTAINER" -- \
    id "$SERVICE_USER" >/dev/null 2>&1; then
    echo "  Setting owner to $SERVICE_USER"
    $NIXOS_CONTAINER run "$CONTAINER" -- \
      chown -R "$SERVICE_USER:$SERVICE_USER" "$CONTAINER_PATH" 2>&1 | sed 's/^/  /'
  else
    echo "  User '$SERVICE_USER' does not exist yet — systemd will set ownership on start"
  fi
else
  echo "  No service user found — skipping permission fix (systemd will set on restart)"
fi

echo ""
echo "Step 6: Starting service..."
echo "  → Starting '$SERVICE'..."
$NIXOS_CONTAINER run "$CONTAINER" -- \
  systemctl start "$SERVICE" 2>&1 | sed 's/^/  /'

# Wait a moment and check status
sleep 2
if $NIXOS_CONTAINER run "$CONTAINER" -- \
  systemctl is-active "$SERVICE" >/dev/null 2>&1; then
  echo "  ✓ Service '$SERVICE' is running"
else
  echo "  ⚠ Service '$SERVICE' may not have started — check logs:"
  echo "     sudo nixos-container run $CONTAINER -- journalctl -u $SERVICE -n 20 --no-pager"
fi

echo ""
echo "=== Restore complete for container '$CONTAINER' ==="
echo ""
echo "Service status:"
$NIXOS_CONTAINER run "$CONTAINER" -- \
  systemctl status "$SERVICE" 2>&1 | head -15 | sed 's/^/  /'

echo ""
echo "Recent logs (last 10 lines):"
$NIXOS_CONTAINER run "$CONTAINER" -- \
  journalctl -u "$SERVICE" -n 10 --no-pager 2>&1 | sed 's/^/  /'
