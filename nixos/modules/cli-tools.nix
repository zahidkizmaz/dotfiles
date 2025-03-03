{
  inputs,
  pkgs,
  system,
  ...
}:
let
  pkgs-unstable = import inputs.nixpkgs-unstable { inherit system; };
  shell_completers = with pkgs-unstable; [
    # These are used as external_completer in nushell
    carapace
    fish
  ];
in
{
  programs = {
    direnv.enable = true;
  };

  environment.systemPackages =
    shell_completers
    ++ (with pkgs; [
      atuin
      bat
      delta
      eza
      fd
      fzf
      jq
      ripgrep
      yazi
      zoxide
    ]);
}
