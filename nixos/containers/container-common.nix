{ lib, ... }:
{
  imports = [
    (import ./monitoring/alloy-log-report.nix { })
  ];
  networking = {
    firewall = {
      enable = true;
    };
    # Use systemd-resolved inside the container
    # Workaround for bug https://github.com/NixOS/nixpkgs/issues/162686
    useHostResolvConf = lib.mkForce false;
  };
  services = {
    resolved.enable = true;
    journald.extraConfig = ''
      MaxRetentionSec=30d
      SystemMaxUse=1G
      SystemMaxFileSize=100M
    '';
  };
}
