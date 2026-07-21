{
  inputs,
  config,
  pkgs,
  ...
}:
let
  pkgs-unstable = import inputs.nixpkgs-unstable { system = pkgs.stdenv.hostPlatform.system; };
in
{
  services = {
    usbmuxd.enable = true;
  };
  programs = {
    obs-studio = {
      enable = true;
      enableVirtualCamera = true;
      plugins = [ pkgs-unstable.obs-studio-plugins.droidcam-obs ];
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
