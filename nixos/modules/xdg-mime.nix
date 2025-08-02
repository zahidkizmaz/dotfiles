{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    feh
    firefox
    mpv
    neovide
    pcmanfm
    xdg-utils
  ];

  xdg = {
    mime.defaultApplications = {
      "application/pdf" = "firefox.desktop";
      "application/x-extension-htm" = "firefox.desktop";
      "application/x-extension-html" = "firefox.desktop";
      "application/x-extension-shtml" = "firefox.desktop";
      "application/x-extension-xht" = "firefox.desktop";
      "application/x-extension-xhtml" = "firefox.desktop";
      "application/xhtml+xml" = "firefox.desktop";
      "audio/*" = "io.mpv.Mpv";
      "image/*" = "feh.desktop";
      "inode/directory" = "pcmanfm.desktop";
      "text/html" = "firefox.desktop";
      "text/plain" = "neovide.desktop";
      "video/*" = "io.mpv.Mpv";
      "x-scheme-handler/about" = "firefox.desktop";
      "x-scheme-handler/chrome" = "firefox.desktop";
      "x-scheme-handler/file" = "pcmanfm.desktop";
      "x-scheme-handler/ftp" = "firefox.desktop";
      "x-scheme-handler/http" = "firefox.desktop";
      "x-scheme-handler/https" = "firefox.desktop";
      "x-scheme-handler/tg" = "telegramdesktop.desktop";
      "x-scheme-handler/unknown" = "firefox.desktop";
    };
  };
}
