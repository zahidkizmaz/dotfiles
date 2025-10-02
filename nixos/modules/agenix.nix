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
    };
  };
}
