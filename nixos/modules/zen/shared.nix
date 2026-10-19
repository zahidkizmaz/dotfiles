let
  extension = shortId: guid: {
    name = guid;
    value = {
      install_url = "https://addons.mozilla.org/en-US/firefox/downloads/latest/${shortId}/latest.xpi";
      installation_mode = "normal_installed";
      private_browsing = true;
    };
  };
in
{
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

    "zen.view.compact.enable-at-startup" = true;
    "zen.view.show-newtab-button-top" = false;

    "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
    # extensions come from policies; never auto-disable ones found in a profile
    "extensions.autoDisableScopes" = 0;

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
    "privacy.clearOnShutdown_v2.formdata" = true;
    "privacy.query_stripping.enabled" = true;
    # RFP pins prefers-color-scheme to light for every site (Bug 1705930).
    # Use Firefox's newer Fingerprinting Protection but exempt the colour-scheme
    # signal, then force dark content.
    "privacy.resistFingerprinting" = false;
    "privacy.fingerprintingProtection" = true;
    "privacy.fingerprintingProtection.pbmode" = false;
    "privacy.fingerprintingProtection.overrides" = "+AllTargets,-CSSPrefersColorScheme";
    "layout.css.prefers-color-scheme.content-override" = 0;
    "privacy.trackingprotection.enabled" = true;
  };

  policies = {
    DisableTelemetry = true;
    DisableAppUpdate = true;
    ExtensionSettings = builtins.listToAttrs [
      (extension "darkreader" "addon@darkreader.org")
      (extension "facebook-container" "@contain-facebook")
      (extension "ublock-origin" "uBlock0@raymondhill.net")
    ];
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
