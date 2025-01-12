{ pkgs, ... }:
let
  fzf = "${pkgs.fzf}/bin/fzf";
  sesh = "${pkgs.sesh}/bin/sesh";
in
{
  environment.shellAliases = {
    ff = "${pkgs.fastfetch}/bin/fastfetch";
    btop = "${pkgs.btop}/bin/btop";
    ls = "${pkgs.eza}/bin/eza";
    sl = "${sesh} connect $(${sesh} list | ${fzf})";
  };
}
