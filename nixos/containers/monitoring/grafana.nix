{
  stateVersion,
  localAddress,
  hostAddress,
  inputs,
  user,
  ...
}:
let
  containerName = "monitoring";
  port = 3000;
  lokiPort = 3100;
  prometheusPort = 9090;
  domain = "${containerName}.quoll-ratio.ts.net";
in
{
  containers.${containerName} = {
    autoStart = true;
    privateNetwork = true;
    privateUsers = "identity";
    enableTun = true;
    ephemeral = false;
    hostAddress = hostAddress;
    localAddress = localAddress;
    bindMounts = {
      "/etc/ssh/lab" = {
        hostPath = "/home/${user}/.ssh/lab";
        isReadOnly = true;
      };
    };
    config =
      {
        config,
        pkgs,
        lib,
        ...
      }:
      {
        imports = [
          ../container-common.nix
          (import ../container-tailscale.nix {
            inherit
              config
              inputs
              lib
              pkgs
              port
              ;
          })
          (import ../tailscale-serve.nix {
            inherit pkgs;
            tailscalePort = lokiPort;
            localPort = lokiPort;
          })
          (import ../tailscale-serve.nix {
            inherit pkgs;
            tailscalePort = prometheusPort;
            localPort = prometheusPort;
          })
        ];

        services = {
          prometheus = {
            enable = true;
            port = prometheusPort;
            extraFlags = [ "--web.enable-remote-write-receiver" ];
          };
          loki = {
            enable = true;
            configuration = {
              auth_enabled = false;
              server = {
                http_listen_port = lokiPort;
              };
              common = {
                replication_factor = 1;
                ring = {
                  instance_addr = "127.0.0.1";
                  kvstore = {
                    store = "inmemory";
                  };
                  replication_factor = 1;
                };
                path_prefix = "/tmp/loki";
              };
              analytics = {
                reporting_enabled = false;
              };
              schema_config = {
                configs = [
                  {
                    from = "2020-05-15";
                    store = "tsdb";
                    object_store = "filesystem";
                    schema = "v13";
                    index = {
                      prefix = "index_";
                      period = "24h";
                    };
                  }
                ];
              };
              storage_config = {
                filesystem = {
                  directory = "/tmp/loki/chunks";
                };
              };
              compactor = {
                working_directory = "/var/lib/loki/compactor";
                retention_enabled = true;
                retention_delete_delay = "2h"; # Delay before deletion
                retention_delete_worker_count = 100; # Number of concurrent deletes
                delete_request_store = "filesystem";
              };
              limits_config = {
                retention_period = "7d"; # Retain logs for 7 days
              };
            };
          };
          grafana = {
            enable = true;
            settings = {
              analytics = {
                enabled = false;
                reporting_enabled = false;
                check_for_updates = false;
                feedback_links_enabled = false;
              };
              server = {
                domain = domain;
                http_port = port;
              };
            };
            provision.datasources.settings = {
              apiVersion = 1;
              prune = true;
              datasources = [
                {
                  name = "Loki";
                  type = "loki";
                  basicAuth = false;
                  isDefault = true;
                  orgId = 1;
                  version = 1;
                  url = "http://127.0.0.1:${toString lokiPort}";
                }
                {
                  name = "Prometheus";
                  type = "prometheus";
                  basicAuth = false;
                  isDefault = false;
                  orgId = 1;
                  version = 1;
                  url = "http://127.0.0.1:${toString prometheusPort}";
                }
              ];
            };
          };
        };

        system.stateVersion = stateVersion;
      };
  };
}
