{
  config,
  stateVersion,
  user,
  inputs,
  ...
}:
{
  virtualisation.containerd.enable = true;
  # networking.nat = {
  #   enable = true;
  #   # Use "ve-*" when using nftables instead of iptables
  #   internalInterfaces = [ "ve-*" ];
  #   externalInterface = "enp2s0";
  #   enableIPv6 = true;
  # };

  networking = {
    bridges.br0.interfaces = [ "enp2s0" ];

    # Get bridge-ip with DHCP
    useDHCP = false;
    interfaces."br0".useDHCP = true;

    # Set bridge-ip static
    interfaces."br0".ipv4.addresses = [
      {
        address = "192.168.100.3";
        prefixLength = 24;
      }
    ];
    defaultGateway = "192.168.100.1";
    nameservers = [ "192.168.100.1" ];
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
