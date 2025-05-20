{ pkgs, inputs, ... }:
let
  pkgs-unstable = import inputs.nixpkgs-unstable { system = pkgs.system; };
in
{
  environment.systemPackages = with pkgs-unstable; [
    # ghostty
    kitty
    sesh
    starship
    tmux
  ];

  fonts.packages = with pkgs; [
    nerd-fonts.iosevka-term
    nerd-fonts.noto
    noto-fonts-color-emoji
  ];
}
