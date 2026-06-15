{ lib, user, ... }:
let
  inherit (lib) types mkOption;
in
{
  options.appContainers = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to enable containers on this host";
    };

    # Per-host container config — just enable/disable (IPs are central in containerMeta)
    containers = mkOption {
      type = types.attrsOf (
        types.submodule {
          options = {
            enable = mkOption {
              type = types.bool;
              default = true;
              description = "Whether this specific container is enabled";
            };
            hostname = mkOption {
              type = types.str;
              default = "";
              description = "Explicit hostname for the container (shown in tailscale)";
            };
            models = mkOption {
              type = types.listOf types.str;
              default = [ ];
              description = "List of models to preload (e.g. ollama model tags)";
            };
          };
        }
      );
      default = { };
    };

    # Per-container config overrides
    overrides = mkOption {
      type = types.attrsOf (types.submodule ({ ... }: { }));
      default = { };
    };

    # Backup configuration
    backup = {
      enable = mkOption {
        type = types.bool;
        default = false;
      };
      hostBackupFolder = mkOption {
        type = types.str;
        default = "/home/${user}/backups";
      };
      resticPassword = mkOption {
        type = types.nullOr types.path;
        default = null;
      };
      targets = mkOption {
        type = types.listOf (
          types.submodule {
            options = {
              name = mkOption { type = types.str; };
              type = mkOption {
                type = types.enum [
                  "local"
                  "rclone"
                ];
              };
              enabled = mkOption {
                type = types.bool;
                default = true;
              };
              mountPath = mkOption {
                type = types.nullOr types.str;
                default = null;
              };
              device = mkOption {
                type = types.nullOr types.str;
                default = null;
              };
              fsType = mkOption {
                type = types.str;
                default = "btrfs";
              };
              mountOptions = mkOption {
                type = types.listOf types.str;
                default = [
                  "defaults"
                  "noatime"
                  "nofail"
                  "compress=zstd"
                ];
              };
              rcloneConfig = mkOption {
                type = types.nullOr types.path;
                default = null;
              };
              remotePath = mkOption {
                type = types.nullOr types.str;
                default = null;
              };
              schedule = mkOption {
                type = types.str;
                default = "03:00";
              };
              prune = mkOption {
                type = types.listOf types.str;
                default = [ "--keep-daily 3" ];
              };
            };
          }
        );
        default = [ ];
      };
      containers = mkOption {
        type = types.listOf (
          types.submodule {
            options = {
              name = mkOption { type = types.str; };
              containerPath = mkOption { type = types.str; };
              backupFolderName = mkOption { type = types.str; };
            };
          }
        );
        default = [ ];
      };
    };
  };
}
