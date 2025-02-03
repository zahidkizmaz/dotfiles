{ ... }:
{
  environment.shellAliases = {
    btop = "nix run nixpkgs#btop";
    ff = "nix run nixpkgs#fastfetch";
  };
}
