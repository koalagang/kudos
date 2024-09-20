{
  disko.devices = {
    disk = {
      main = {
        type = "disk";
	      # the device can be /dev/nvme0n1 (if it's an nvme SSD), /dev/vda (if it's in a VM) or /dev/sda (all other devices)
        device = "/dev/vda";
        content = {
          type = "gpt";
          partitions = {
            ESP = {
              size = "1G";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = [
                  "defaults"
		              # very important for security
		              # (without it, random-seed file is world-readable)
		              "umask=0077"
                ];
              };
            };
            luks = {
              size = "100%";
              content = {
                type = "luks";
                name = "crypted";
                content = {
                  type = "btrfs";
                  extraArgs = [ "-f" "-L nixos" ];
                  subvolumes = {
                    "/root" = {
                      mountpoint = "/";
                      mountOptions = [ "subvol=root" "compress=zstd" "noatime" ];
                    };
                    "/nix" = {
                      mountpoint = "/nix";
                      mountOptions = [ "subvol=nix" "compress=zstd" "noatime" ];
                    };
                    "/persist" = {
                      mountpoint = "/persist";
                      mountOptions = [ "subvol=persist" "compress=zstd" "noatime" ];
                    };
                    "/swap" = {
                      mountpoint = "/swap";
                      mountOptions = [ "subvol=swap" "compress=zstd" "noatime" ];
                      swap.swapfile.size = "17G";
                    };
                  };
                };
              };
            };
          };
        };
      };
    };
  };
}
