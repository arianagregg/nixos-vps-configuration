{ config, lib, pkgs, ... }:

{
  # Note `lib.mkBefore` is used instead of `lib.mkAfter` here.
  boot.initrd.postResumeCommands = pkgs.lib.mkBefore ''
    MOUNT=$(mktemp -d)

    # We first mount the btrfs root
    # so we can manipulate btrfs subvolumes.
    mount -o subvol=/ /dev/disk/by-label/nixos-root "$MOUNT"

    btrfs subvolume list -o "$MOUNT/tmp/root" |
    cut -f9 -d' ' |
    while read subvolume; do
      echo "deleting $subvolume subvolume..."
      btrfs subvolume delete "$MOUNT/$subvolume"
    done &&
    echo "deleting temporary root subvolume..." &&
    btrfs subvolume delete "$MOUNT/tmp/root"

    echo "deleting srv subvolume..." &&
    btrfs subvolume delete "$MOUNT/srv"

    btrfs subvolume list -o "$MOUNT/var" |
    cut -f9 -d' ' |
    while read subvolume; do
      echo "deleting $subvolume subvolume..."
      btrfs subvolume delete "$MOUNT/$subvolume"
    done

    echo "restoring blank root subvolume..."
    btrfs subvolume snapshot "$MOUNT/tmp/root@blank" "$MOUNT/tmp/root"

    # Once we're done rolling back to a blank snapshot,
    # we can unmount /mnt and continue on the boot process.
    umount "$MOUNT"
    rm -rf "$MOUNT"
  '';

  environment.persistence."/persist" = {
    hideMounts = true;
    files = [
      "/etc/ssh/ssh_host_ed25519_key"
      "/etc/ssh/ssh_host_ed25519_key.pub"
      "/etc/ssh/ssh_host_rsa_key"
      "/etc/ssh/ssh_host_rsa_key.pub"
      "/var/lib/systemd/catalog/database" # Needed for historical journalctl
                                          # logs to work
    ];
    directories = [
      "/var/lib/nixos"
      "/var/lib/systemd/coredump"
      "/var/log"
      {
        directory = "/var/lib/pds";
	user = "pds";
	group = "pds";
	mode = "755";
      }
      {
        directory = "/var/lib/acme";
        user = "acme";
        group = "acme";
	mode = "755";
      }
      {
        directory = "/var/www";
        user = "nginx";
        group = "nginx";
        mode = "755";
      }
      {
        directory = "${config.services.postgresql.dataDir}";
	user = "postgres";
	group = "postgres";
	mode = "700";
      }
    ];
  };
}
