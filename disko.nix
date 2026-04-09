{
  disko.devices.disk = {
    main = {
      type = "disk";
      device = "/dev/sda";
      content = {
        type = "gpt";
        partitions = {
          boot = {
            size = "1M";
            type = "EF02";
            priority = 1;
          };
          ESP = {
            size = "512M";
            type = "EF00";
            content = {
              type = "filesystem";
              format = "vfat";
              mountpoint = "/boot";
            };
          };
          root = {
            label = "root";
            size = "100%";
            content = {
              type = "btrfs";
              extraArgs = [ "-L" "nixos-root" "-f" ];
              subvolumes = {
                "/tmp" = {};
                "/tmp/root" = {
                  mountpoint = "/";
                };
                "/persist" = {
                  mountpoint = "/persist";
                };
                "/persist/nix" = {
                  mountOptions = [
                    "noatime"
                    "compress=zstd"
                  ];
                  mountpoint = "/nix";
                };
                "/swap" = {
                  mountpoint = "/swap";
                  swap = {
                    swapfile.size = "8G";
                  };
                };
              };
            };
          };
        };
      };
      postCreateHook = ''
      MOUNT=$(mktemp -d)
      mount "/dev/disk/by-label/nixos-root" "$MOUNT"
      trap 'umount $MOUNT; rm -rf $MOUNT' EXIT
      btrfs subvol snapshot "$MOUNT/tmp/root" "$MOUNT/tmp/root@blank"
      '';
    };
  };
  fileSystems."/persist".neededForBoot = true;
}
