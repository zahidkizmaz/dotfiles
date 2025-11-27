{ pkgs, inputs, ... }:
let
  pkgs-unstable = import inputs.nixpkgs-unstable { system = pkgs.stdenv.hostPlatform.system; };
in
{
  environment.systemPackages = with pkgs-unstable; [
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
