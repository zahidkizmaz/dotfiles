# Self Hosted Containers

## Backup

3 2 1 backup strategy.

For external drive we need drive to be labeled "backup-drive".
Here is a command to format to drive:

### Create backup-drive

Device must be unmounted.

```bash
sudo mkfs.btrfs -f -L backup-drive /dev/sdb1
```

**Manual Mounting**: `sudo mount -m -o defaults,noatime,compress=zstd,space_cache=v2,ssd /dev/sdb1 /backup`

## Restore

Get rclone config from agenix to ~/.config/rclone/rclone.conf

then run:

```bash
mkdir restore-repo
rclone copy filen-backend:backups ./restore-repo --progress
mkdir restored-data
restic -r restore-repo restore latest --target restored-data/
```

### Restore immich

- Stop the immich services:

    ```bash
    nixos-container run immich -- systemctl stop immich-server.service immich-machine-learning.service
    ```

- Copy immich data:

    ```bash
    machinectl copy-to immich restored-data/immich /var/lib/immich
    nixos-container run immich -- chown -R immich:immich /var/lib/immich
    ```

- Restore postgres db from latest backup:

    ```bash
    gunzip --stdout "/path/to/backup/dump.sql.gz" |
      sed "s/SELECT pg_catalog.set_config('search_path', '', false);/SELECT pg_catalog.set_config('search_path', 'public, pg_catalog', true);/g" \
        nixos-container run immich -- sudo -u postgres psql immich
    ```

- Start immich services:

    ```bash
    nixos-container run immich -- systemctl start immich-server.service immich-machine-learning.service
    ```
