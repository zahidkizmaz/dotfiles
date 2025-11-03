let
  lab = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJ4fh0Rr/ASYtfbx+rY9JUm25tnhIxobntSVbrSfZQ7o tech@zahid.rocks";

  fw13 = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHFE+eQtUGF7XMr1XAfDSkzFNXE1A7EdjMNTjTDnQ3CS root@fw13-amd";
  pi4b = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBonUDIYvzaKlQeyxNYs3QdLUyLEMMASt6mVbiWM2xbC root@pi4b";
  hosts = [
    fw13
    pi4b
  ];
  everyone = [ lab ] ++ hosts;
in
{
  "home_latitude.age".publicKeys = everyone;
  "home_longitude.age".publicKeys = everyone;
  "home_elevation.age".publicKeys = everyone;
  "tailscale-lab.age".publicKeys = everyone;
  "restic-password.age".publicKeys = [
    lab
    fw13
  ];
  "searx-secret.age".publicKeys = [
    lab
    fw13
  ];
  "rclone-config-filen.age".publicKeys = [
    lab
    fw13
  ];
  "companion_env.age".publicKeys = [
    lab
    fw13
  ];
  "invidious_extra_conf.age".publicKeys = [
    lab
    fw13
  ];

}
