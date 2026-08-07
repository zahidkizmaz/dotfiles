{ pkgs, inputs, ... }:
{
  environment.systemPackages = [
    inputs.agenix.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];

  age = {
    secrets = {
      tailscale-pi4b.file = ../../secrets/tailscale-pi4b.age;
    };
  };
}
