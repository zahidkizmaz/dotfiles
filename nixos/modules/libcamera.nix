{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    libcamera-qcam
  ];

  systemd.user.services.wireplumber.environment.LIBCAMERA_IPA_PROXY_PATH = "${pkgs.libcamera}/libexec/libcamera";

}
