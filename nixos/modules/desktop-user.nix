{
  inputs,
  pkgs,
  user,
  system,
  ...
}:
let
  pkgs-unstable = import inputs.nixpkgs-unstable { inherit system; };
in
{
  imports = [
    ./anyrun.nix
    ./cli-tools.nix
  ];

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users."${user}" = {
    isNormalUser = true;
    initialPassword = "${user}";
    description = "${user}";
    extraGroups = [
      "networkmanager"
      "input"
      "wheel"
      "video"
      "audio"
      "storage"
      "cups"
      "libvirtd"
    ];
    shell = pkgs-unstable.zsh;
  };
  programs.zsh.enable = true;

  fonts.packages = with pkgs; [
    nerd-fonts.arimo
    nerd-fonts.iosevka-term
    nerd-fonts.noto
    nerd-fonts.jetbrains-mono
    noto-fonts-color-emoji
  ];
}
