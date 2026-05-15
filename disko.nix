{ ... }:
{
  disko.devices = {
    disk = {
      main = {
        device = "/dev/nvme0n1";
        type = "disk";
        content = {
          type = "gpt";
          partitions = {
            esp = {
              size = "1G";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = [ "umask=0077" ];
              };
            };
            root = {
              size = "100%";
              content = {
                type = "luks";
                name = "cryptroot";
                settings = {
                  allowDiscards = true;    # TRIM for NVMe health
                  bypassWorkqueues = true; # perf: reduce latency on NVMe
                };
                extraFormatArgs = [
                  "--type"
                  "luks2"
                  "--cipher"
                  "aes-xts-plain64"
                  "--key-size"
                  "512"
                  "--hash"
                  "sha512"
                  "--pbkdf"
                  "argon2id"
                  "--pbkdf-memory"
                  "1048576" # 1GB RAM for KDF
                  "--iter-time"
                  "5000"
                ];
                # echo -n "passphrase" > /tmp/disk-password before running disko
                passwordFile = "/tmp/disk-password";
                content = {
                  type = "btrfs";
                  extraArgs = [ "-f" ];
                  subvolumes = {
                    "@" = {
                      mountpoint = "/";
                      mountOptions = [
                        "compress=zstd:3"
                        "noatime"
                      ];
                    };
                    "@home" = {
                      mountpoint = "/home";
                      mountOptions = [
                        "compress=zstd:3"
                        "noatime"
                      ];
                    };
                    "@nix" = {
                      mountpoint = "/nix";
                      mountOptions = [
                        "compress=zstd:1"
                        "noatime"
                      ];
                    };
                    "@games" = {
                      mountpoint = "/games";
                      mountOptions = [
                        "nodatacow"
                        "noatime"
                      ];
                    };
                    # nodatacow + no compression required for btrfs swapfiles.
                    # disko creates the swapfile via `btrfs filesystem mkswapfile`.
                    "@swap" = {
                      mountpoint = "/swap";
                      mountOptions = [
                        "nodatacow"
                        "noatime"
                      ];
                      swap.swapfile.size = "32G";
                    };
                    "@snapshots" = {
                      mountpoint = "/.snapshots";
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
