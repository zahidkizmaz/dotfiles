{ inputs, user, ... }:
{
  environment.systemPackages = [
    inputs.agenix.packages.x86_64-linux.default
  ];

  age = {
    identityPaths = [ "/home/${user}/.ssh/lab" ];
    secrets = {
      tailscale-lab.file = ../secrets/tailscale-lab.age;
      restic-password.file = ../secrets/restic-password.age;
      rclone-config-filen.file = ../secrets/rclone-config-filen.age;
      rclone-config-pcloud.file = ../secrets/rclone-config-pcloud.age;
      fw13-nix-signing.file = ../secrets/fw13-nix-signing.age;
      grafana-sa-token = {
        file = ../secrets/grafana-sa-token.age;
        owner = user;
      };
    };
  };
}
