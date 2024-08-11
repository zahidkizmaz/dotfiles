{ pkgs, user, ... }:
{
  security.sudo.wheelNeedsPassword = false;
  users.users.${user} = {
    isNormalUser = true;
    initialPassword = "${user}";
    shell = pkgs.zsh;
    extraGroups = [ "input" "wheel" "video" "audio" "storage" ];
  };
}
