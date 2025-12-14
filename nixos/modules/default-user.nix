{ pkgs, user, ... }:
{
  programs.zsh.enable = true;
  users.users.${user} = {
    isNormalUser = true;
    initialPassword = "${user}";
    shell = pkgs.zsh;
    extraGroups = [
      "audio"
      "input"
      "networkmanager"
      "storage"
      "systemd-journal"
      "video"
      "wheel"
    ];
  };
}
