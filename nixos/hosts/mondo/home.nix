{
  user,
  stateVersion,
  ...
}:
{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "${user}";
  home.homeDirectory = "/Users/${user}";

  imports = [
    ../../modules/home-manager/nix-index-database.nix
  ];

  targets.darwin.copyApps.enable = true;

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
  home.stateVersion = stateVersion;
}
