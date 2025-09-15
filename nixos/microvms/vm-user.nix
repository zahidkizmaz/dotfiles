{ pkgs, ... }:
{
  programs.zsh.enable = true;
  users.users.vm = {
    isNormalUser = true;
    initialPassword = "vm";
    shell = pkgs.zsh;
    extraGroups = [
      "input"
      "wheel"
      "video"
      "audio"
      "storage"
    ];
  };
}
