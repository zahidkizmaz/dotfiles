{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    mpv
    telegram-desktop
  ];
}
