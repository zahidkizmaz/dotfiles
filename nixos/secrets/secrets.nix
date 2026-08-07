let
  lab = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJ4fh0Rr/ASYtfbx+rY9JUm25tnhIxobntSVbrSfZQ7o tech@zahid.rocks";
  fw13 = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHFE+eQtUGF7XMr1XAfDSkzFNXE1A7EdjMNTjTDnQ3CS root@fw13-amd";
  pi4b = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKoioZynKCzzbPoHOpOSJOZLgt8E3BV1cP0jWR6UK2vo pi@pi4b";
  pi5 = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDu+qDPwSRpMp8462gIxViwZZd1jfH1jJjtOOk3bKiKq root@raspberrypi";
  hosts = [
    fw13
    pi4b
    pi5
  ];
  everyone = [ lab ] ++ hosts;
in
{
  "home_latitude.age".publicKeys = everyone;
  "home_longitude.age".publicKeys = everyone;
  "home_elevation.age".publicKeys = everyone;
  "tailscale-lab.age".publicKeys = everyone;
  "tailscale-pi4b.age".publicKeys = [
    lab
    pi4b
  ];
  "restic-password.age".publicKeys = [
    lab
    fw13
    pi5
  ];
  "searx-secret.age".publicKeys = [
    lab
    fw13
  ];
  "rclone-config-filen.age".publicKeys = [
    lab
    fw13
    pi5
  ];
  "rclone-config-pcloud.age".publicKeys = [
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
  "grafana-secret-key.age".publicKeys = [
    lab
    fw13
  ];
  "fw13-nix-signing.age".publicKeys = [
    fw13
    lab
  ];
  "forgejo-runner1-config.age".publicKeys = [
    fw13
    lab
  ];
  "forgejo-hermes-token.age".publicKeys = [
    fw13
    lab
  ];
  "hermes-dashboard-auth.age".publicKeys = [
    fw13
    lab
  ];
  "attic-jwt-secret.age".publicKeys = [
    fw13
    lab
  ];
  "attic-token.age".publicKeys = [
    fw13
    lab
    pi4b
    pi5
  ];
  "grafana-sa-token.age".publicKeys = [
    fw13
    lab
    pi4b
  ];
  "hass-mcp-key.age".publicKeys = [
    fw13
    lab
    pi5
  ];
}
