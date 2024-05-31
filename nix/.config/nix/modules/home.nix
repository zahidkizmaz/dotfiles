{ config, pkgs, inputs, user, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "${user}";
  home.homeDirectory = "/home/${user}";

  qt = {
    enable = true;
    platformTheme.name = "gtk";
  };

  gtk = {
    enable = true;
    cursorTheme.name = "macOS-Monterey-Dark";
    cursorTheme.package = pkgs.apple-cursor;
    iconTheme.name = "Papirus-Dark";
    iconTheme.package = pkgs.papirus-icon-theme;
    theme.name = "Catppuccin-Mocha-Standard-Pink-Dark";
    theme.package = pkgs.catppuccin-gtk.override {
      accents = [ "pink" ];
      size = "standard";
      variant = "mocha";
    };
  };

  xdg.enable = true;
  xdg.configFile = {
    "gtk-4.0/assets".source = "${config.gtk.theme.package}/share/themes/${config.gtk.theme.name}/gtk-4.0/assets";
    "gtk-4.0/gtk.css".source = "${config.gtk.theme.package}/share/themes/${config.gtk.theme.name}/gtk-4.0/gtk.css";
    "gtk-4.0/gtk-dark.css".source = "${config.gtk.theme.package}/share/themes/${config.gtk.theme.name}/gtk-4.0/gtk-dark.css";
  };

  programs.firefox = {
    enable = true;

    profiles.zahid = {
      settings = {
        "browser.startup.homepage" = "https://www.startpage.com/do/mypage.pl?prfe=2fb91ba78884cffd12306b0ab6163c87719b53a4238821eba5f075668d1a3ced3d3397730521889373e40a0c51fe15f1c81f900111ae63ca76a4ac74f7c0e1b62b071d861f10587a255615fe";
        "browser.aboutConfig.showWarning" = false;
        "browser.compactmode.show" = true;
        "browser.download.panel.shown" = true;
        "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;
        "browser.shell.checkDefaultBrowser" = false;
        "browser.shell.defaultBrowserCheckCount" = 1;
        "extensions.pocket.enabled" = false;
        "identity.fxaccounts.enabled" = false;
        "signon.rememberSignons" = false;
        "widget.use-xdg-desktop-portal.file-picker" = 1;

        # security
        "dom.security.https_only_mode" = true;
        "dom.security.https_only_mode_ever_enabled" = true;

        # privacy
        "browser.send_pings" = false;
        "dom.battery.enabled" = false;
        "dom.event.clipboardevents.enabled" = false;
        "geo.enabled" = false;
        "network.cookie.cookieBehavior" = 1;
        "network.http.referer.trimmingPolicy" = 2;
        "privacy.resistFingerprinting" = true;
        "privacy.trackingprotection.enabled" = true;

        # telemetry
        "browser.newtabpage.activity-stream.feeds.telemetry" = false;
        "browser.newtabpage.activity-stream.telemetry" = false;
        "browser.ping-centre.telemetry" = false;
        "datareporting.healthreport.service.enabled" = false;
        "datareporting.healthreport.uploadEnabled" = false;
        "datareporting.policy.dataSubmissionEnabled" = false;
        "datareporting.sessions.current.clean" = true;
        "devtools.onboarding.telemetry.logged" = false;
        "toolkit.telemetry.archive.enabled" = false;
        "toolkit.telemetry.bhrPing.enabled" = false;
        "toolkit.telemetry.enabled" = false;
        "toolkit.telemetry.firstShutdownPing.enabled" = false;
        "toolkit.telemetry.hybridContent.enabled" = false;
        "toolkit.telemetry.newProfilePing.enabled" = false;
        "toolkit.telemetry.pioneer-new-studies-available" = false;
        "toolkit.telemetry.prompted" = 2;
        "toolkit.telemetry.rejected" = true;
        "toolkit.telemetry.reportingpolicy.firstRun" = false;
        "toolkit.telemetry.server" = "";
        "toolkit.telemetry.shutdownPingSender.enabled" = false;
        "toolkit.telemetry.unified" = false;
        "toolkit.telemetry.unifiedIsOptIn" = false;
        "toolkit.telemetry.updatePing.enabled" = false;

        # UI
        "browser.uiCustomization.state" = "{\"placements\":{\"widget-overflow-fixed-list\":[],\"unified-extensions-area\":[\"_20fc2e06-e3e4-4b2b-812b-ab431220cada_-browser-action\",\"_74145f27-f039-47ce-a470-a662b129930a_-browser-action\",\"_testpilot-containers-browser-action\",\"_contain-facebook-browser-action\"],\"nav-bar\":[\"back-button\",\"forward-button\",\"stop-reload-button\",\"home-button\",\"customizableui-special-spring1\",\"urlbar-container\",\"customizableui-special-spring2\",\"zoom-controls\",\"screenshot-button\",\"downloads-button\",\"unified-extensions-button\",\"ublock0_raymondhill_net-browser-action\",\"addon_darkreader_org-browser-action\"],\"toolbar-menubar\":[\"menubar-items\"],\"TabsToolbar\":[\"tabbrowser-tabs\",\"new-tab-button\",\"alltabs-button\"],\"PersonalToolbar\":[\"import-button\",\"personal-bookmarks\"]},\"seen\":[\"save-to-pocket-button\",\"developer-button\",\"ublock0_raymondhill_net-browser-action\",\"_74145f27-f039-47ce-a470-a662b129930a_-browser-action\",\"_20fc2e06-e3e4-4b2b-812b-ab431220cada_-browser-action\",\"addon_darkreader_org-browser-action\",\"_testpilot-containers-browser-action\",\"_contain-facebook-browser-action\"],\"dirtyAreaCache\":[\"nav-bar\",\"PersonalToolbar\",\"unified-extensions-area\",\"toolbar-menubar\",\"TabsToolbar\"],\"currentVersion\":20,\"newElementCount\":4}";
      };

      search = {
        force = true;
        default = "Startpage";
        engines = {
          "Startpage" = {
            urls = [{
              template = "https://www.startpage.com/sp/search";
              params = [
                { name = "query"; value = "{searchTerms}"; }
              ];
            }];
            icon = "";
            definedAliases = [ "@sp" ];
          };
          "Nix Packages" = {
            urls = [{
              template = "https://search.nixos.org/packages";
              params = [
                { name = "type"; value = "packages"; }
                { name = "query"; value = "{searchTerms}"; }
              ];
            }];
            icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
            definedAliases = [ "@np" ];
          };
          "Github Search" = {
            urls = [{
              template = "https://github.com/search";
              params = [
                { name = "q"; value = "{searchTerms}"; }
                { name = "type"; value = "repositories"; }
              ];
            }];
            icon = "";
            definedAliases = [ "@gh" ];
          };
        };
      };

      bookmarks = [
        {
          name = "Arch Linux";
          tags = [ ];
          keyword = "arch";
          url = "https://archlinux.org/";
        }
        {
          name = "Github";
          tags = [ ];
          keyword = "gh";
          url = "https://github.com/";
        }
        {
          name = "Home Manager Search";
          tags = [ ];
          keyword = "home";
          url = "https://home-manager-options.extranix.com/?query=%s&release=master";
        }
      ];

      extensions = with inputs.firefox-addons.packages."x86_64-linux"; [
        clearurls
        darkreader
        facebook-container
        ublock-origin
      ];
    };
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
  home.stateVersion = "23.11";
}