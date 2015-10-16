backup() {
    ( set -e
    grep -q /mnt/backups /proc/mounts || {
        echo "Mounting backup storage"
        sudo mount -t nfs 10.42.1.2:/volume1/backups /mnt/backups/
    }
    echo "Backing up to /mnt/backups/$(hostname -s)"
    sudo rsync -av --exclude-from=/home/dennis/.config/backup_exclude --delete --delete-excluded / /mnt/backups/$(hostname -s)/
    )
}
