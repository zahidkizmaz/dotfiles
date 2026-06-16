{ lib, ... }:
{
  nix = {
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

  networking = {
    firewall = {
      enable = true;
    };
    # Use systemd-resolved inside the container
    # Workaround for bug https://github.com/NixOS/nixpkgs/issues/162686
    useHostResolvConf = lib.mkForce false;
  };
  services = {
    resolved = {
      enable = true;
      settings = {
        Resolve = {
          # Explicitly enable DNS stub listener on 127.0.0.53:53.
          # Without this, systemd-resolved may detect "foreign" mode inside
          # containers (because the symlink chain goes through /etc/static/)
          # and silently disable the stub listener, leaving /etc/resolv.conf
          # with no nameserver entries — which breaks Go's DNS resolver.
          DNSStubListener = "yes";
        };
      };
    };
    journald.extraConfig = ''
      MaxRetentionSec=30d
      SystemMaxUse=1G
      SystemMaxFileSize=100M
    '';
  };
}
