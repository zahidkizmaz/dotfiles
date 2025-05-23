{ user, stateVersion, ... }:
{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "${user}";
  home.homeDirectory = "/home/${user}";

  imports = [
    ../../modules/home-manager/linux-ui.nix
    ../../modules/home-manager/firefox.nix
    ../../modules/home-manager/dconf-virt-manager-qemu.nix
  ];

  services.easyeffects = {
    enable = true;
    preset = "fw-13-easyeffecs"; # Comes from easyeffects config dir
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
  home.stateVersion = stateVersion;
}
