{ config, ... }:

{
  imports = [
    ../../modules/host-networking.nix
    ../../containers
  ];

  hostNetworking = {
    enable = true;
    externalInterface = "enp2s0"; # TODO: verify with `ip link`
    tailscaleAuthKey = config.age.secrets.tailscale-lab.path;
  };

  # NO containers enabled yet
  appContainers = {
    enable = false;
    backup.enable = false;
  };
}
