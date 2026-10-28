{
  pkgs,
  inputs,
  lib,
  ...
}:
let
  pkgs-unstable = import inputs.nixpkgs-unstable { system = pkgs.stdenv.hostPlatform.system; };

  # nixpkgs' `ghostty` source build is Linux-only; on Darwin we use the
  # prebuilt universal binary (`ghostty-bin`).
  ghosttyPkg =
    if pkgs.stdenv.hostPlatform.isDarwin then pkgs-unstable.ghostty-bin else pkgs-unstable.ghostty;

  # foot is Wayland-only.
  footPackages = lib.optionals pkgs.stdenv.hostPlatform.isLinux [ pkgs-unstable.foot ];
in
{
  environment.systemPackages =
    with pkgs-unstable;
    [
      ghosttyPkg
      kitty
      sesh
      starship
      tmux
    ]
    ++ footPackages;

  fonts.packages = with pkgs; [
    nerd-fonts.iosevka-term
    nerd-fonts.noto
    noto-fonts-color-emoji
  ];
}
