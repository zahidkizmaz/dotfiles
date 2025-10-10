# Self Hosted Containers

## Backup

3 2 1 backup strategy.

For external drive we need drive to be labeled "backup-drive".
Here is a command to format to drive:

Device must be unmounted.

```bash
sudo mkfs.btrfs -f -L backup-drive /dev/sda1
```
