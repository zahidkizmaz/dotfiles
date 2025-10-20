{ inputs, system, ... }:
{
  environment.systemPackages = [
    inputs.agenix.packages."${system}".default
  ];

  age = {
    secrets = {
      tailscale-lab.file = ../../secrets/tailscale-lab.age;
    };
  };
}
