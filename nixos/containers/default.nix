{
  config,
  stateVersion,
  user,
  inputs,
  ...
}:
let
  bridgeInterface = "br0";
in
{
  virtualisation.containerd.enable = true;
  networking.nat = {
    enable = true;
    internalInterfaces = [ "ve-*" ];
    externalInterface = bridgeInterface;
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
      hostAddress = "192.168.100.1";
      localAddress = "192.168.100.5";
      port = 8080;
      inherit
        stateVersion
        inputs
        user
        bridgeInterface
        ;
    })
    # (import ./paperless-ngx.nix {
    #   hostAddress = "192.168.100.3";
    #   localAddress = "192.168.100.4";
    #   port = 8080;
    #   inherit stateVersion inputs user;
    # })
  ];
}
