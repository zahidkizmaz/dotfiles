{ config, pkgs, ... }:
let
  pl =
    (pkgs.obs-studio-plugins.droidcam-obs.override {
      ffmpeg_7 = pkgs.ffmpeg;
    }).overrideAttrs
      (prev: {
        version = "2.4.2-unstable-2025-10-14";

        src = pkgs.fetchFromGitHub {
          owner = "dev47apps";
          repo = "droidcam-obs-plugin";
          rev = "161cb95b8dc5fe77185e52a9783dc45c6d137165";
          sha256 = "sha256-3GClykaJjjmasEnSVGU5jnz+xoznaSYTxBz7jkhj0m4=";
        };
      });
in
{
  services = {
    usbmuxd.enable = true;
  };
  programs = {
    obs-studio = {
      enable = true;
      enableVirtualCamera = true;
      plugins = [ pl ];
    };
  };
  environment.systemPackages = with pkgs; [
    droidcam
    v4l-utils # For v4l2-ctl and v4l2loopback tools.
  ];

  boot = {
    extraModulePackages = with config.boot.kernelPackages; [ v4l2loopback ];
    kernelModules = [ "v4l2loopback" ];
    extraModprobeConfig = ''
      options v4l2loopback video_nr=10 card_label=DroidCamCam exclusive_caps=1
    '';
  };
}
