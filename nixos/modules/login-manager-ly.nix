{ ... }:
{
  # Needs to wait for this: https://codeberg.org/fairyglade/ly/issues/227
  services.displayManager.ly = {
    enable = true;
    x11Support = false;
    settings = {
      save = true;
    };
  };
}
