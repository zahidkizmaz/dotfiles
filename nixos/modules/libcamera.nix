{ pkgs, inputs, ... }:
let
  pkgs-unstable = import inputs.nixpkgs-unstable {
    system = pkgs.system;
  };
in
{
  environment.systemPackages = with pkgs-unstable; [
    libcamera-qcam
  ];

  systemd.user.services.wireplumber.environment.LIBCAMERA_IPA_PROXY_PATH = "${pkgs.libcamera-qcam}/libexec/libcamera";

}
