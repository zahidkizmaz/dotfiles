{
  stateVersion,
  localAddress,
  hostAddress,
  inputs,
  user,
  models,
  ...
}:
let
  containerName = "ollama";
  port = 11434;
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
          ./container-common.nix
          (import ./container-tailscale.nix {
            inherit
              config
              inputs
              lib
              pkgs
              port
              ;
          })
        ];

        services.ollama = {
          enable = true;
          host = "0.0.0.0";
          port = port;
          openFirewall = true;
          package = pkgs.ollama-cpu;
          loadModels = models;
          syncModels = true;
          environmentVariables = {
            OLLAMA_KEEP_ALIVE = "-1";
            OLLAMA_CONTEXT_LENGTH = "32768";
          };
        };

        system.stateVersion = stateVersion;
      };
  };
}
