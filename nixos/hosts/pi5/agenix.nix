{ pkgs, inputs, ... }:
{
  environment.systemPackages = [
    inputs.agenix.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];

  age = {
    secrets = {
      tailscale-lab.file = ../../secrets/tailscale-lab.age;
    };
  };
}
