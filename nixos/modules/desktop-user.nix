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
    shell = pkgs-unstable.nushell;
    packages = with pkgs-unstable; [
      gitMinimal
      just
      stow
      tree
      unzip
      zip
      # nushell plugins
      nushellPlugins.polars
    ];
  };

  fonts.packages = with pkgs; [
    (nerdfonts.override {
      fonts = [
        "Arimo"
        "IosevkaTerm"
        "Noto"
        "JetBrainsMono"
      ];
    })
    noto-fonts-color-emoji
  ];
}
