{
  inputs,
  pkgs,
  lib,
  ...
}:
let
  extension = shortId: guid: {
    name = guid;
    value = {
      install_url = "https://addons.mozilla.org/en-US/firefox/downloads/latest/${shortId}/latest.xpi";
      installation_mode = "normal_installed";
      private_browsing = true;
    };
  };
  prefs = {
    "browser.startup.homepage" = "https://www.startpage.com/";
    "browser.aboutConfig.showWarning" = false;
    "browser.compactmode.show" = true;
    "browser.download.panel.shown" = true;
    "browser.newtabpage.activity-stream.feeds.section.topstories" = false;
    "browser.newtabpage.activity-stream.showSponsored" = false;
    "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;
    "browser.newtabpage.activity-stream.system.showSponsored" = false;
    "browser.shell.checkDefaultBrowser" = false;
    "browser.shell.defaultBrowserCheckCount" = 1;
    "identity.fxaccounts.enabled" = false;
    "signon.rememberSignons" = false;
    "widget.use-xdg-desktop-portal.file-picker" = 1;

    "zen.view.compact.enable-at-startup" = true;
    "zen.view.show-newtab-button-top" = false;

    "layout.css.devPixelsPerPx" = "1.5";
    "toolkit.legacyUserProfileCustomizations.stylesheets" = true;

    # hardware acceleration
    "gfx.color_management.native_srgb" = true;
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
    "privacy.clearOnShutdown_v2.formdata" = true;
  };

  extensions = [
    (extension "clearurls" "{74145f27-f039-47ce-a470-a662b129930a}")
    (extension "darkreader" "addon@darkreader.org")
    (extension "facebook-container" "@contain-facebook")
    (extension "ublock-origin" "uBlock0@raymondhill.net")
  ];
in
{
  environment.systemPackages = [
    (pkgs.wrapFirefox
      inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.zen-browser-unwrapped
      {
        extraPrefs = lib.concatLines (
          lib.mapAttrsToList (
            name: value: "lockPref(${lib.strings.toJSON name}, ${lib.strings.toJSON value});"
          ) prefs
        );

        extraPolicies = {
          DisableTelemetry = true;
          DisableAppUpdate = true;
          ExtensionSettings = builtins.listToAttrs extensions;

          SearchEngines = {
            Default = "Startpage";
            Add = [
              {
                Name = "Startpage";
                URLTemplate = "https://www.startpage.com/sp/search?query={searchTerms}";
                Alias = "@sp";
              }
              {
                Name = "Nix Packages";
                URLTemplate = "https://search.nixos.org/packages?type=packages&query={searchTerms}";
                Alias = "@nix";
              }
              {
                Name = "Nix Package Versions";
                URLTemplate = "https://lazamar.co.uk/nix-versions?channel=nixos-unstable&package={searchTerms}";
                Alias = "@nixv";
              }
              {
                Name = "Github Search";
                URLTemplate = "https://github.com/search?q={searchTerms}&type=repositories";
                Alias = "@gh";
              }
            ];
          };
        };
      }
    )
  ];
}
