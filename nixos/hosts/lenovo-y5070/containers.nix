{ config, ... }:

{
  imports = [
    ../../modules/host-networking.nix
    ../../containers
  ];

  hostNetworking = {
    enable = true;
    externalInterface = "enp9s0";
    tailscaleAuthKey = config.age.secrets.tailscale-lab.path;
  };

  appContainers = {
    enable = true;
    containers = {
      ollama = {
        enable = true;
        models = [ "gemma4:e4b" ];
      };
    };
    backup.enable = false;
  };
}
