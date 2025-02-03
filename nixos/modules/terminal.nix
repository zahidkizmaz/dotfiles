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
    (nerdfonts.override {
      fonts = [
        "IosevkaTerm"
        "Noto"
      ];
    })
    noto-fonts-color-emoji
  ];
}
