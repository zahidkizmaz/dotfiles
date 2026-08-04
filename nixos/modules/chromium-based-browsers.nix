{
  pkgs,
  ...
}:
{
  # Policies are shared between all Chromium-based browsers: the module writes
  # them to /etc/chromium/, /etc/opt/chrome/ and /etc/brave/policies/managed/.
  programs.chromium = {
    enable = true;

    homepageLocation = "https://search.quoll-ratio.ts.net/";
    defaultSearchProviderEnabled = true;
    defaultSearchProviderSearchURL = "https://search.quoll-ratio.ts.net/search?q={searchTerms}";
    defaultSearchProviderSuggestURL = "https://search.quoll-ratio.ts.net/autocompleter?q={searchTerms}";

    extensions = [
      "ddkjiahejlhfcafbddmgiahcphecmpfh"
    ];

    extraOpts = {
      # no Google phone-home
      "MetricsReportingEnabled" = false;
      "UrlKeyedAnonymizedDataCollectionEnabled" = false;
      "ComponentUpdatesEnabled" = false; # update.googleapis.com checks
      "BackgroundModeEnabled" = false;
      "NetworkPredictionOptions" = 2; # no prefetch/preconnect
      "SearchSuggestEnabled" = false;
      "AlternateErrorPagesEnabled" = false;
      "TranslateEnabled" = false;

      # privacy sandbox (Topics/FLEDGE)
      "PrivacySandboxAdMeasurementEnabled" = false;
      "PrivacySandboxAdTopicsEnabled" = false;
      "PrivacySandboxSiteEnabledAdsEnabled" = false;
      "PrivacySandboxPromptEnabled" = false;

      # no account / sync / password manager
      "BrowserSignin" = 0;
      "SyncDisabled" = true;
      "PasswordManagerEnabled" = false;
      "AutofillAddressEnabled" = false;
      "AutofillCreditCardEnabled" = false;

      # privacy
      "BlockThirdPartyCookies" = true;
      "DefaultGeolocationSetting" = 2;
      "HttpsOnlyMode" = 1;
      "DefaultNotificationsSetting" = 3; # ask site notification prompts
      "DefaultPopupsSetting" = 2; # block popups
      "ExtensionInstallBlocklist" = [ "*" ]; # only force-installed (uBOL) extensions
      # Trade-off: disables phishing/http interstitials in exchange for no
      # Google URL lookups. Drop this if you want safe-browsing warnings back.
      "SafeBrowsingEnabled" = false;
      "PasswordLeakDetectionEnabled" = false; # no password hashes sent to Google

      # UI
      "BookmarkBarEnabled" = false; # no bookmarks bar (Ctrl+Shift+B still toggles)
    };
  };

  environment.systemPackages = [
    (pkgs.ungoogled-chromium.override { enableWideVine = true; })
    pkgs.brave
  ];
}
