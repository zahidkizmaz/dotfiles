{ pkgs, ... }:
{
  environment.shellAliases = {
    ff = "${pkgs.fastfetch}/bin/fastfetch";
    btop = "${pkgs.btop}/bin/btop";
  };
}
