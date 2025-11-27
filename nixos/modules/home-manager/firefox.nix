{ inputs, pkgs, ... }:
{
  programs.firefox = {
    enable = true;
    package = pkgs.firefox;

    profiles.zahid = {
      extensions.packages = with inputs.firefox-addons.packages.${pkgs.system}; [
        clearurls
        darkreader
        facebook-container
        ublock-origin
      ];
      settings = {
        "browser.startup.homepage" = "https://search.quoll-ratio.ts.net/";
        "browser.aboutConfig.showWarning" = false;
        "browser.compactmode.show" = true;
        "browser.download.panel.shown" = true;
        "browser.newtabpage.activity-stream.discoverystream.saveToPocketCard.enabled" = false;
        "browser.newtabpage.activity-stream.discoverystream.sendToPocket.enabled" = false;
        "browser.newtabpage.activity-stream.feeds.section.topstories" = false;
        "browser.newtabpage.activity-stream.section.highlights.includePocket" = false;
        "browser.newtabpage.activity-stream.showSponsored" = false;
        "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;
        "browser.newtabpage.activity-stream.system.showSponsored" = false;
        "browser.shell.checkDefaultBrowser" = false;
        "browser.shell.defaultBrowserCheckCount" = 1;
        "browser.urlbar.suggest.pocket" = false;
        "extensions.activeThemeID" = "cheers-bold-colorway@mozilla.org";
        "extensions.pocket.bffRecentSaves" = false;
        "extensions.pocket.enabled" = false;
        "extensions.pocket.showHome" = false;
        "identity.fxaccounts.enabled" = false;
        "services.sync.prefs.sync.browser.newtabpage.activity-stream.feeds.section.topstories" = false;
        "services.sync.prefs.sync.browser.newtabpage.activity-stream.section.topstories.rows" = false;
        "services.sync.prefs.sync.browser.newtabpage.activity-stream.showSponsored" = false;
        "services.sync.prefs.sync.browser.newtabpage.activity-stream.showSponsoredTopSites" = false;
        "services.sync.prefs.sync-seen.browser.newtabpage.activity-stream.section.highlights.includePocket" =
          false;
        "services.sync.prefs.sync.browser.newtabpage.activity-stream.section.highlights.includePocket" =
          false;
        "signon.rememberSignons" = false;
        "widget.use-xdg-desktop-portal.file-picker" = 1;

        # performance
        "browser.tabs.unloadOnLowMemory" = true;
        "browser.low_commit_space_threshold_percent" = 100;
        "min_inactive_duration_before_unload" = 3600000; # 1 hour

        "browser.cache.disk.enable" = false;
        "browser.cache.memory.enable" = true;
        "browser.cache.memory.capacity" = -1; # automatic memory management

        # hardware acceleration
        "gfx.webrender.all" = true;
        "gfx.webrender.overlay-vp-auto-hdr" = true;
        "gfx.color_management.native_srgb" = true;
        "media.ffmpeg.vaapi.enabled" = true;
        "media.hardware-video-decoding.force-enabled" = true;

        # security
        "dom.security.https_only_mode" = true;
        "dom.security.https_only_mode_ever_enabled" = true;

        # privacy
        "browser.newtabpage.activity-stream.weather.locationSearchEnabled" = false;
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
        "browser.newtabpage.activity-stream.telemetry.structuredIngestion.endpoint" = "";
        "browser.ping-centre.telemetry" = false;
        "browser.search.serpEventTelemetryCategorization.enabled" = false;
        "datareporting.healthreport.service.enabled" = false;
        "datareporting.healthreport.uploadEnabled" = false;
        "datareporting.policy.dataSubmissionEnabled" = false;
        "datareporting.sessions.current.clean" = true;
        "devtools.onboarding.telemetry.logged" = false;
        "identity.fxaccounts.telemetry.clientAssociationPing.enabled" = false;
        "network.trr.confirmation_telemetry_enabled" = false;
        "nimbus.telemetry.targetingContextEnabled" = false;
        "telemetry.fog.init_on_shutdown" = false;
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
        "browser.uiCustomization.state" =
          "{\"placements\":{\"widget-overflow-fixed-list\":[],\"unified-extensions-area\":[\"_20fc2e06-e3e4-4b2b-812b-ab431220cada_-browser-action\",\"_74145f27-f039-47ce-a470-a662b129930a_-browser-action\",\"_testpilot-containers-browser-action\",\"_contain-facebook-browser-action\"],\"nav-bar\":[\"back-button\",\"forward-button\",\"stop-reload-button\",\"home-button\",\"customizableui-special-spring1\",\"urlbar-container\",\"customizableui-special-spring2\",\"zoom-controls\",\"screenshot-button\",\"downloads-button\",\"unified-extensions-button\",\"ublock0_raymondhill_net-browser-action\",\"addon_darkreader_org-browser-action\"],\"toolbar-menubar\":[\"menubar-items\"],\"TabsToolbar\":[\"tabbrowser-tabs\",\"new-tab-button\",\"alltabs-button\"],\"PersonalToolbar\":[\"import-button\",\"personal-bookmarks\"]},\"seen\":[\"save-to-pocket-button\",\"developer-button\",\"ublock0_raymondhill_net-browser-action\",\"_74145f27-f039-47ce-a470-a662b129930a_-browser-action\",\"_20fc2e06-e3e4-4b2b-812b-ab431220cada_-browser-action\",\"addon_darkreader_org-browser-action\",\"_testpilot-containers-browser-action\",\"_contain-facebook-browser-action\"],\"dirtyAreaCache\":[\"nav-bar\",\"PersonalToolbar\",\"unified-extensions-area\",\"toolbar-menubar\",\"TabsToolbar\"],\"currentVersion\":20,\"newElementCount\":4}";
      };

      search = {
        force = true;
        default = "Searxng";
        engines = {
          "Startpage" = {
            urls = [
              {
                template = "https://www.startpage.com/sp/search";
                params = [
                  {
                    name = "query";
                    value = "{searchTerms}";
                  }
                ];
              }
            ];
            icon = "";
            definedAliases = [ "@sp" ];
          };
          "Searxng" = {
            urls = [
              {
                template = "https://search.quoll-ratio.ts.net/search";
                params = [
                  {
                    name = "q";
                    value = "{searchTerms}";
                  }
                ];
              }
            ];
            definedAliases = [ "@s" ];
          };
          "Nix Packages" = {
            urls = [
              {
                template = "https://search.nixos.org/packages";
                params = [
                  {
                    name = "type";
                    value = "packages";
                  }
                  {
                    name = "query";
                    value = "{searchTerms}";
                  }
                ];
              }
            ];
            icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
            definedAliases = [ "@nix" ];
          };
          "Nix Package Versions" = {
            urls = [
              {
                template = "https://lazamar.co.uk/nix-versions";
                params = [
                  {
                    name = "channel";
                    value = "nixos-unstable";
                  }
                  {
                    name = "package";
                    value = "{searchTerms}";
                  }
                ];
              }
            ];
            icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
            definedAliases = [ "@nixv" ];
          };
          "Github Search" = {
            urls = [
              {
                template = "https://github.com/search";
                params = [
                  {
                    name = "q";
                    value = "{searchTerms}";
                  }
                  {
                    name = "type";
                    value = "repositories";
                  }
                ];
              }
            ];
            icon = "";
            definedAliases = [ "@gh" ];
          };
        };
      };

      bookmarks = {
        force = true;
        settings = [
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
            keyword = "homeman";
            url = "https://home-manager-options.extranix.com/?query=%s&release=master";
          }
          {
            name = "AdGuard";
            tags = [ "selfhosted" ];
            keyword = "dns";
            url = "https://dns.quoll-ratio.ts.net";
          }
          {
            name = "Home Assistant";
            tags = [ "selfhosted" ];
            keyword = "";
            url = "https://home.quoll-ratio.ts.net";
          }
          {
            name = "Immich";
            tags = [ "selfhosted" ];
            keyword = "immich";
            url = "https://immich.quoll-ratio.ts.net";
          }
          {
            name = "KaraKeep";
            tags = [ "selfhosted" ];
            keyword = "keep";
            url = "https://keep.quoll-ratio.ts.net";
          }
          {
            name = "Mealie";
            tags = [ "selfhosted" ];
            keyword = "meal";
            url = "https://meal.quoll-ratio.ts.net";
          }
          {
            name = "Monitoring";
            tags = [ "selfhosted" ];
            keyword = "logs";
            url = "https://monitoring.quoll-ratio.ts.net";
          }
          {
            name = "Music - Navidrome";
            tags = [ "selfhosted" ];
            keyword = "music";
            url = "https://music.quoll-ratio.ts.net";
          }
          {
            name = "Ntfy";
            tags = [ "selfhosted" ];
            keyword = "ntfy";
            url = "https://ntfy.quoll-ratio.ts.net";
          }
          {
            name = "Paperless";
            tags = [ "selfhosted" ];
            keyword = "paper";
            url = "https://paperless.quoll-ratio.ts.net";
          }
          {
            name = "StirlingPDF";
            tags = [ "selfhosted" ];
            keyword = "pdf";
            url = "https://pdf.quoll-ratio.ts.net";
          }
          {
            name = "Searxng";
            tags = [ "selfhosted" ];
            keyword = "";
            url = "https://search.quoll-ratio.ts.net";
          }
          {
            name = "Uptime Kuma";
            tags = [ "selfhosted" ];
            keyword = "uptime";
            url = "https://status.quoll-ratio.ts.net";
          }
          {
            name = "Watch";
            tags = [ "selfhosted" ];
            keyword = "watch";
            url = "https://watch.quoll-ratio.ts.net";
          }
        ];
      };
    };
  };
}
