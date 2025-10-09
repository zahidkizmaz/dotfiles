{
  config,
  stateVersion,
  user,
  inputs,
  ...
}:
let
  hostAddress = "192.168.100.10";
in
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
    (import ./monitoring/alloy-log-report.nix { })
    (import ./immich.nix {
      localAddress = "192.168.100.11";
      inherit
        stateVersion
        inputs
        user
        hostAddress
        ;
    })
    (import ./searx.nix {
      localAddress = "192.168.100.13";
      inherit
        stateVersion
        inputs
        user
        hostAddress
        ;
    })
    (import ./adguard.nix {
      localAddress = "192.168.100.14";
      inherit
        stateVersion
        inputs
        user
        hostAddress
        ;
    })
    (import ./stirling-pdf.nix {
      localAddress = "192.168.100.15";
      inherit
        stateVersion
        inputs
        user
        hostAddress
        ;
    })
    (import ./navidrome.nix {
      localAddress = "192.168.100.16";
      inherit
        stateVersion
        inputs
        user
        hostAddress
        ;
    })
    (import ./monitoring {
      localAddress = "192.168.100.17";
      inherit
        stateVersion
        inputs
        user
        hostAddress
        ;
    })
    (import ./paperless.nix {
      localAddress = "192.168.100.18";
      inherit
        stateVersion
        inputs
        user
        hostAddress
        ;
    })
  ];
}
