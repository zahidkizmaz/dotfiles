{ ... }:
{
  services.openssh.enable = true;
  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJ4fh0Rr/ASYtfbx+rY9JUm25tnhIxobntSVbrSfZQ7o tech@zahid.rocks"
  ];
}
