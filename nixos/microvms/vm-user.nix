{ pkgs, ... }:
{
  services.openssh = {
    enable = true;
    # Start a systemd service for each incoming SSH connection
    startWhenNeeded = true;
  };
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
