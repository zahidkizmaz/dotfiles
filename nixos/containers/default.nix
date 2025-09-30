{
  config,
  stateVersion,
  user,
  inputs,
  ...
}:
{
  virtualisation.containerd.enable = true;
  networking.nat = {
    enable = true;
    internalInterfaces = [ "ve-+" ];
    externalInterface = "enp2s0";
  };

  services = {
    tailscale = {
      enable = true;
      openFirewall = true;
      authKeyFile = config.age.secrets.tailscale-lab.path;
    };
  };

  imports = [
    (import ./immich.nix {
      hostAddress = "192.168.100.10";
      localAddress = "192.168.100.11";
      port = 8080;
      inherit stateVersion inputs user;
    })
    (import ./paperless-ngx.nix {
      hostAddress = "192.168.100.3";
      localAddress = "192.168.100.4";
      port = 8080;
      inherit stateVersion inputs user;
    })
  ];
}
