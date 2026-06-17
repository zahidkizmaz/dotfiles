set -euo pipefail

usage() {
  cat <<'USAGE'
Usage: pg-upgrade-container <container> <from_version> <to_version> [service]

Migrate PostgreSQL data in a NixOS container from one PG major version to another.

Arguments:
  container     Container name (e.g., paperless, mealie)
  from_version  Old PostgreSQL major version (e.g., 16, 17)
  to_version    New PostgreSQL major version (e.g., 18)
  service       Optional: systemd service to stop/start.
                Defaults to container name. Use empty string "" to only manage postgresql.

Examples:
  sudo pg-upgrade-container paperless 17 18
  sudo pg-upgrade-container mealie 16 18
  sudo pg-upgrade-container paperless 16 17 paperless
USAGE
}

if [ "$(id -u)" -ne 0 ]; then
  echo "error: this script must be run as root (use sudo)" >&2
  exit 1
fi

if [ $# -lt 3 ]; then
  usage
  exit 1
fi

CONTAINER="$1"
OLD_VER="$2"
NEW_VER="$3"
SERVICE="${4:-$CONTAINER}"
DATA_DIR="/var/lib/postgresql"

# Validate numeric versions
if ! [[ $OLD_VER =~ ^[0-9]+$ ]] || ! [[ $NEW_VER =~ ^[0-9]+$ ]]; then
  echo "error: versions must be numbers (e.g., 16, 17, 18)" >&2
  exit 1
fi

if [ "$OLD_VER" -ge "$NEW_VER" ]; then
  echo "error: old version must be less than new version" >&2
  exit 1
fi

NIXOS_CONTAINER="@nixos_container@/bin/nixos-container"

# Resolve a PG major version to a /nix/store path with its bin/ directory.
# Tries /nix/store first, then falls back to nix build if the binary is
# not cached locally (e.g. garbage collected).
find_pg_bin() {
  local ver="$1"
  local bin

  # First check if already in the store
  bin=$(find /nix/store -maxdepth 1 -type d -name "postgresql-${ver}*" 2>/dev/null \
    | grep -vE '\-(man|lib|dev)$' \
    | head -1)

  if [ -z "$bin" ] && command -v nix &>/dev/null; then
    echo "  -> PostgreSQL $ver not in /nix/store; downloading with nix..." >&2
    bin=$(nix build "nixpkgs#postgresql_${ver}^out" --no-link --print-out-paths 2>/dev/null || true)
  fi

  if [ -n "$bin" ]; then
    echo "$bin"
    return 0
  fi
  return 1
}

OLD_BIN=$(find_pg_bin "$OLD_VER") || {
  echo "error: could not find PostgreSQL $OLD_VER anywhere" >&2
  echo "" >&2
  echo "Tried /nix/store and 'nix build nixpkgs#postgresql_$OLD_VER'." >&2
  echo "Make sure you have a network connection and nixpkgs in your flake registry." >&2
  exit 1
}

NEW_BIN=$(find_pg_bin "$NEW_VER") || {
  echo "error: could not find PostgreSQL $NEW_VER anywhere" >&2
  echo "" >&2
  echo "Tried /nix/store and 'nix build nixpkgs#postgresql_$NEW_VER'." >&2
  echo "Make sure you have a network connection and nixpkgs in your flake registry." >&2
  exit 1
}

echo "=== PostgreSQL Upgrade: $CONTAINER ($OLD_VER => $NEW_VER) ==="
echo "  Container: $CONTAINER"
echo "  Service:   $SERVICE"
echo "  Old PG:    $OLD_BIN"
echo "  New PG:    $NEW_BIN"
echo ""

# Check container exists and is running
if ! $NIXOS_CONTAINER status "$CONTAINER" >/dev/null 2>&1; then
  echo "error: container '$CONTAINER' is not running" >&2
  echo "Start it with: nixos-container start $CONTAINER" >&2
  exit 1
fi

# Check old data directory exists
if ! $NIXOS_CONTAINER run "$CONTAINER" -- \
  test -d "$DATA_DIR/$OLD_VER" 2>/dev/null; then
  echo "error: data directory $DATA_DIR/$OLD_VER not found in container" >&2
  echo "Checked inside container '$CONTAINER'." >&2
  exit 1
fi

# Check old data has actual content
old_files=$($NIXOS_CONTAINER run "$CONTAINER" -- \
  ls -1 "$DATA_DIR/$OLD_VER" 2>/dev/null | wc -l)
if [ "$old_files" -le 3 ]; then
  echo "error: old data directory $DATA_DIR/$OLD_VER appears empty" >&2
  echo "Found only $old_files entries. Nothing to migrate." >&2
  exit 1
fi

# Ensure new data directory exists
if ! $NIXOS_CONTAINER run "$CONTAINER" -- \
  test -d "$DATA_DIR/$NEW_VER" 2>/dev/null; then
  echo "Creating new PG data directory $DATA_DIR/$NEW_VER..."
  $NIXOS_CONTAINER run "$CONTAINER" -- \
    mkdir -p "$DATA_DIR/$NEW_VER"
  $NIXOS_CONTAINER run "$CONTAINER" -- \
    chown postgres:postgres "$DATA_DIR/$NEW_VER"
fi

echo "Step 1: Stopping services..."
if [ -n "$SERVICE" ]; then
  $NIXOS_CONTAINER run "$CONTAINER" -- \
    systemctl stop "$SERVICE" postgresql 2>&1 | sed 's/^/  /' || true
else
  $NIXOS_CONTAINER run "$CONTAINER" -- \
    systemctl stop postgresql 2>&1 | sed 's/^/  /' || true
fi
sleep 2

echo "Step 2: Backing up current $NEW_VER data directory..."
backup_label="${NEW_VER}.bak-$(date +%Y%m%d-%H%M%S)"
$NIXOS_CONTAINER run "$CONTAINER" -- \
  cp -a "$DATA_DIR/$NEW_VER" "$DATA_DIR/$backup_label" 2>&1 | sed 's/^/  /' || true

echo "Step 3: Checking checksum alignment..."
old_bindir="$OLD_BIN/bin"
new_bindir="$NEW_BIN/bin"

# PG 18 enables data checksums by default on initdb, but pg_upgrade requires
# matching settings. If the old cluster doesn't have checksums, re-init the
# new data dir to match before proceeding.
old_checksum_ver=$($NIXOS_CONTAINER run "$CONTAINER" -- \
  su -s /bin/sh postgres -c \
  "'$new_bindir/pg_controldata' '$DATA_DIR/$OLD_VER'" 2>/dev/null \
  | grep "Data page checksum version" | awk '{print $NF}')
new_checksum_ver=$($NIXOS_CONTAINER run "$CONTAINER" -- \
  su -s /bin/sh postgres -c \
  "'$new_bindir/pg_controldata' '$DATA_DIR/$NEW_VER'" 2>/dev/null \
  | grep "Data page checksum version" | awk '{print $NF}')

echo "  Old cluster checksum version: ${old_checksum_ver:-unknown}"
echo "  New cluster checksum version: ${new_checksum_ver:-unknown}"

if [ "$old_checksum_ver" != "$new_checksum_ver" ]; then
  echo "  Mismatch detected. Re-initializing new data directory without checksums..."

  $NIXOS_CONTAINER run "$CONTAINER" -- \
    rm -rf "$DATA_DIR/$NEW_VER"

  $NIXOS_CONTAINER run "$CONTAINER" -- \
    su -s /bin/sh postgres -c \
    "'$new_bindir/initdb' --no-data-checksums -D '$DATA_DIR/$NEW_VER'" 2>&1 | sed 's/^/  /'

  echo "  Re-initialization complete."
fi

echo "Step 4: Checking old cluster configuration..."

# The old cluster's postgresql.conf may be a symlink to a Nix store path
# that was garbage collected. If it's missing or broken, generate a minimal
# config from the PG sample so the server can start.
$NIXOS_CONTAINER run "$CONTAINER" -- \
  su -s /bin/sh postgres -c \
  "config='$DATA_DIR/$OLD_VER/postgresql.conf'; \
   if [ -L \"\$config\" ] && [ ! -e \"\$config\" ]; then \
     echo '  -> Broken symlink detected, generating config from sample...'; \
     cp '$old_bindir/../share/postgresql/postgresql.conf.sample' \"\$config\"; \
   elif [ ! -f \"\$config\" ]; then \
     echo '  -> Config file missing, generating from sample...'; \
     cp '$old_bindir/../share/postgresql/postgresql.conf.sample' \"\$config\"; \
   else \
     echo '  -> Config file OK'; \
   fi" 2>&1 | sed 's/^/  /'

echo "Step 5: Running pg_upgrade..."
echo "  (this may take a while for large databases)"
echo ""

# pg_upgrade must run as the postgres user. Use /tmp as working dir for log output.
if $NIXOS_CONTAINER run "$CONTAINER" -- \
  su -s /bin/sh postgres -c \
  "cd /tmp && '$new_bindir/pg_upgrade' \
    -b '$old_bindir' \
    -B '$new_bindir' \
    -d '$DATA_DIR/$OLD_VER' \
    -D '$DATA_DIR/$NEW_VER'"; then
  echo ""
  echo "=== Migration complete! ==="
  echo ""
  echo "Step 6: Starting services..."
  if [ -n "$SERVICE" ]; then
    $NIXOS_CONTAINER run "$CONTAINER" -- \
      systemctl start postgresql "$SERVICE" 2>&1 | sed 's/^/  /'
  else
    $NIXOS_CONTAINER run "$CONTAINER" -- \
      systemctl start postgresql 2>&1 | sed 's/^/  /'
  fi
  echo ""
  echo "PostgreSQL $OLD_VER => $NEW_VER migration successful for container '$CONTAINER'"
  echo ""
  echo "To clean up:"
  echo "  Old data: sudo nixos-container run $CONTAINER -- rm -rf $DATA_DIR/$OLD_VER"
  echo "  Backup:   sudo nixos-container run $CONTAINER -- rm -rf $DATA_DIR/$backup_label"
  echo ""
  echo "Run 'analyze_new_cluster.sh' to update planner statistics:"
  echo "  sudo nixos-container run $CONTAINER -- \\"
  echo "    su -s /bin/sh postgres -c 'cd /tmp && sh analyze_new_cluster.sh'"
else
  pg_status=$?
  echo ""
  echo "=== Migration FAILED (exit code $pg_status) ==="
  echo "Check upgrade logs in the container:"
  echo "  sudo nixos-container run $CONTAINER -- ls -la /tmp/pg_upgrade*.log"
  echo ""
  echo "Restoring original $NEW_VER directory from backup..."
  if $NIXOS_CONTAINER run "$CONTAINER" -- \
    test -d "$DATA_DIR/$backup_label" 2>/dev/null; then
    $NIXOS_CONTAINER run "$CONTAINER" -- \
      rm -rf "$DATA_DIR/$NEW_VER" 2>/dev/null || true
    $NIXOS_CONTAINER run "$CONTAINER" -- \
      mv "$DATA_DIR/$backup_label" "$DATA_DIR/$NEW_VER" 2>/dev/null || true
    echo "Restored original $NEW_VER data from backup."
  fi
  echo "Starting PostgreSQL with original data..."
  $NIXOS_CONTAINER run "$CONTAINER" -- \
    systemctl start postgresql 2>&1 | sed 's/^/  /' || true
  exit $pg_status
fi
