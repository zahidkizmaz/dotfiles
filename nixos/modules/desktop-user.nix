{ pkgs, user, ... }:
{
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users."${user}" = {
    isNormalUser = true;
    initialPassword = "${user}";
    description = "${user}";
    extraGroups = [
      "audio"
      "cups"
      "input"
      "librepods"
      "libvirtd"
      "networkmanager"
      "storage"
      "video"
      "wheel"
    ];
    shell = pkgs.zsh;
  };
  programs = {
    librepods.enable = true;
    zsh.enable = true;
  };

  fonts = {
    packages = with pkgs; [
      nerd-fonts.arimo
      nerd-fonts.iosevka-term
      nerd-fonts.noto
      nerd-fonts.jetbrains-mono
      noto-fonts-color-emoji
    ];
    fontDir.enable = true;
  };
}
