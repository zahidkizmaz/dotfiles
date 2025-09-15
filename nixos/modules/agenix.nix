{ inputs, ... }:
{
  environment.systemPackages = [
    inputs.agenix.packages.x86_64-linux.default
  ];
  age.secrets.tailscale-lab.file = ../secrets/tailscale-lab.age;
}
