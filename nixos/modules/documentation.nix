{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    man
    tealdeer
  ];
}
