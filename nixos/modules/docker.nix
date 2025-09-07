{ pkgs, user, ... }:
{
  virtualisation = {
    docker = {
      enable = true;
      rootless.setSocketVariable = true;
    };
  };

  environment.systemPackages = with pkgs; [
    docker-compose
  ];

  users.users.${user}.extraGroups = [ "docker" ];
}
