{ pkgs, user, ... }:
{
  programs.zsh.enable = true;
  users.users.${user} = {
    isNormalUser = true;
    initialPassword = "${user}";
    shell = pkgs.zsh;
    extraGroups = [
      "input"
      "wheel"
      "video"
      "audio"
      "storage"
      "networkmanager"
    ];
  };
  imports = [ ./cli-tools.nix ];
}
