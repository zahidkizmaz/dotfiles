{ user, ... }:
{
  services.openssh = {
    enable = true;
    # Start a systemd service for each incoming SSH connection
    startWhenNeeded = true;
  };
  programs.ssh.startAgent = true;

  users.users.${user}.openssh.authorizedKeys.keys = [
    # lab
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJ4fh0Rr/ASYtfbx+rY9JUm25tnhIxobntSVbrSfZQ7o tech@zahid.rocks"
  ];
}
