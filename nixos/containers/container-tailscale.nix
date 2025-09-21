{ inputs, config, ... }:
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

  services.tailscale = {
    enable = true;
    authKeyFile = config.age.secrets.tailscale-lab.path;
  };
}
