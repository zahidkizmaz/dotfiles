{ pkgs, ... }:
{
  hardware.ledger.enable = true;
  environment.systemPackages = [ pkgs.ledger-live-desktop ];
}
