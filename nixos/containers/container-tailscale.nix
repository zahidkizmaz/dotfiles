{
  inputs,
  pkgs,
  config,
  port,
  ...
}:
{
  imports = [ inputs.agenix.nixosModules.default ];
  age = {
    identityPaths = [ "/etc/ssh/lab" ];
    secrets = {
      tailscale-lab = {
        file = ../secrets/tailscale-lab.age;
      };
    };
  };

  services = {
    tailscale = {
      enable = true;
      openFirewall = true;
      authKeyFile = config.age.secrets.tailscale-lab.path;
      authKeyParameters.ephemeral = true;
    };
  };
  systemd.services.tailscale-serve = {
    description = "Tailscale Serve HTTP Proxy";
    wants = [ "tailscale.service" ];
    after = [ "tailscale.service" ];
    serviceConfig = {
      ExecStart = "${pkgs.tailscale}/bin/tailscale serve --http=80 localhost:${toString port}";
      Restart = "always";
    };
    wantedBy = [ "multi-user.target" ];
  };
}
