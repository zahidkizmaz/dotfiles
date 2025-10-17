{
  pkgs,
  user,
  stateVersion,
  ...
}:
{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "${user}";
  home.homeDirectory = "/home/${user}";

  imports = [
    ../../modules/home-manager/firefox.nix
    ../../modules/home-manager/dconf-virt-manager-qemu.nix
    ../../modules/home-assistant/home_assistant_desktop_entry.nix
  ];

  dconf = {
    enable = true;
    settings = {
      # GNOME settings:
      "org/gnome/desktop/interface" = {
        color-scheme = "prefer-dark";
        show-battery-percentage = true;
      };

      "org/gnome/desktop/input-sources" = {
        xkb-options = [ "caps:escape" ];
      };

      "org/gnome/settings-daemon/plugins/media-keys" = {
        custom-bindings = [ "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/" ];
      };
      "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
        bindings = "<Shift><Super>x";
        command = "copyq toggle";
        name = "copyq toggle";
      };

      "org/gnome/desktop/wm/keybindings" = {
        close = [ "<Super>q" ];
        maximize = [ "<Super>m" ];
        switch-to-workspace-1 = [ "<Control>1" ];
        switch-to-workspace-2 = [ "<Control>2" ];
        switch-to-workspace-3 = [ "<Control>3" ];
        switch-to-workspace-4 = [ "<Control>4" ];
        move-to-workspace-1 = [ "<Shift><Control>1" ];
        move-to-workspace-2 = [ "<Shift><Control>2" ];
        move-to-workspace-3 = [ "<Shift><Control>3" ];
        move-to-workspace-4 = [ "<Shift><Control>4" ];
      };
      "org/gnome/shell" = {
        disable-user-extensions = false; # enables user extensions
        enabled-extensions = with pkgs.gnomeExtensions; [
          applications-menu.extensionUuid
          removable-drive-menu.extensionUuid
          window-gestures.extensionUuid
          caffeine.extensionUuid
        ];
      };
      "org/gnome/shell/extensions/windowgestures" = {
        swipe3-down = 0;
        swipe3-left = 0;
        swipe3-right = 0;
        swipe4-left = 18;
        swipe4-right = 18;
        swipe4-updown = 1;
        three-finger = true;
        use-active-window = true;
      };
    };
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
  home.stateVersion = stateVersion;
}
