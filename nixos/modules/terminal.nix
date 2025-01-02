{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    kitty
    starship
    tmux
  ];

  fonts.packages = with pkgs; [
    (nerdfonts.override { fonts = [ "IosevkaTerm" "Noto" ]; })
    noto-fonts-color-emoji
  ];
}
