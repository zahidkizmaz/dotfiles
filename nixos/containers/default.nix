{
  config,
  stateVersion,
  user,
  inputs,
  ...
}:
{
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
    ./backup.nix
    (import ./immich.nix {
      hostAddress = "192.168.100.10";
      localAddress = "192.168.100.11";
      port = 8080;
      inherit stateVersion inputs user;
    })
    (import ./paperless-ngx.nix {
      hostAddress = "192.168.100.10";
      localAddress = "192.168.100.12";
      port = 8080;
      inherit stateVersion inputs user;
    })
    (import ./searx.nix {
      hostAddress = "192.168.100.10";
      localAddress = "192.168.100.13";
      port = 8080;
      inherit stateVersion inputs user;
    })
    (import ./adguard.nix {
      hostAddress = "192.168.100.10";
      localAddress = "192.168.100.14";
      port = 3000;
      inherit stateVersion inputs user;
    })
  ];
}
