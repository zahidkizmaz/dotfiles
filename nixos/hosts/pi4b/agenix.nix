{ inputs, ... }:
{
  environment.systemPackages = [
    inputs.agenix.packages.x86_64-linux.default
  ];

  age = {
    secrets = {
      home_elevation.file = ../../secrets/home_elevation.age;
      home_latitude.file = ../../secrets/home_latitude.age;
      home_longitude.file = ../../secrets/home_longitude.age;
    };
  };
}
