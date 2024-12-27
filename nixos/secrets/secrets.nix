let
  lab = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJ4fh0Rr/ASYtfbx+rY9JUm25tnhIxobntSVbrSfZQ7o tech@zahid.rocks";
  pi4b = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKoioZynKCzzbPoHOpOSJOZLgt8E3BV1cP0jWR6UK2vo pi@pi4b";
in
{
  "home_latitude.age".publicKeys = [ lab pi4b ];
  "home_longitude.age".publicKeys = [ lab pi4b ];
  "home_elevation.age".publicKeys = [ lab pi4b ];
}
