{ pkgs, ... }:
let
  browser = "zen-beta.desktop";
  imageViewer = "feh.desktop";
in
{
  environment.systemPackages = with pkgs; [
    feh
    mpv
    neovide
    kdePackages.dolphin
    xdg-utils
  ];

  xdg = {
    mime.defaultApplications = {
      "application/pdf" = browser;
      "application/x-extension-htm" = browser;
      "application/x-extension-html" = browser;
      "application/x-extension-shtml" = browser;
      "application/x-extension-xht" = browser;
      "application/x-extension-xhtml" = browser;
      "application/xhtml+xml" = browser;
      "audio/*" = "io.mpv.Mpv";
      "image/*" = imageViewer;
      "image/gif" = imageViewer;
      "image/jpeg" = imageViewer;
      "image/png" = imageViewer;
      "image/webp" = imageViewer;
      "inode/directory" = "org.kde.dolphin.desktop";
      "text/html" = browser;
      "text/plain" = "neovide.desktop";
      "video/*" = "io.mpv.Mpv";
      "x-scheme-handler/about" = browser;
      "x-scheme-handler/chrome" = browser;
      "x-scheme-handler/file" = "org.kde.dolphin.desktop";
      "x-scheme-handler/ftp" = browser;
      "x-scheme-handler/http" = browser;
      "x-scheme-handler/https" = browser;
      "x-scheme-handler/tg" = "telegramdesktop.desktop";
      "x-scheme-handler/unknown" = browser;
    };
  };
}
