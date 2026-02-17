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
            size = "100%";
            content = {
              type = "btrfs";
              extraArgs = [ "-f" ];
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
	    mountpoint = "none";
          };
        };
      };
      postCreateHook = "btrfs subvol snapshot /tmp/root /tmp/root@blank";
    };
  };
}
