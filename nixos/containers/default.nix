{
  stateVersion,
  user,
  inputs,
  ...
}:
{
  virtualisation.containerd.enable = true;
  networking.nat = {
    enable = true;
    # Use "ve-*" when using nftables instead of iptables
    internalInterfaces = [ "ve-+" ];
    externalInterface = "ens3";
  };

  imports = [
    (import ./immich.nix {
      hostAddress = "192.168.100.1";
      localAddress = "192.168.100.2";
      port = 8080;
      inherit stateVersion inputs user;
    })
    # (import ./paperless-ngx.nix {
    #   hostAddress = "192.168.100.3";
    #   localAddress = "192.168.100.4";
    #   port = 8080;
    #   inherit stateVersion inputs user;
    # })
  ];
}
