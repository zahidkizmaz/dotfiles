{
  user,
  stateVersion,
  inputs,
  system,
  ...
}:
let
  pkgs-unstable = import inputs.nixpkgs-unstable { inherit system; };
in
{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "${user}";
  home.homeDirectory = "/home/${user}";

  imports = [
    ../../modules/home-manager/dconf-virt-manager-qemu.nix
    ../../modules/home-manager/firefox.nix
    ../../modules/home-manager/linux-ui.nix
    ../../modules/home-manager/nix-index-database.nix
  ];

  services.easyeffects = {
    enable = true;
    preset = "fw-13-easyeffecs"; # Comes from easyeffects config dir
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
  home.stateVersion = stateVersion;

  # Hyprland Lua API stubs for lua-language-server
  home.file.".local/share/hyprland/stubs".source = "${pkgs-unstable.hyprland}/share/hypr/stubs";
}
