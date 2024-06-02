{ lib, pkgs, user, config, ... }:
{
  hardware = {
    bluetooth.enable = true;
    bluetooth.powerOnBoot = true;
  };
  networking = {
    hostName = "pi4b";
    interfaces.eth0.useDHCP = true;
    wireless.enable = false;

    firewall.enable = true;
    firewall.allowedTCPPorts = [ 22 443 ];
  };

  security.sudo.wheelNeedsPassword = false;
  users.users.${user} = {
    isNormalUser = true;
    shell = pkgs.zsh;
    extraGroups = [ "input" "wheel" "video" "audio" "storage" ];
  };
  programs = {
    zsh = {
      enable = true;
      autosuggestions.enable = true;
      syntaxHighlighting.enable = true;
    };
    starship.enable = true;
  };

  i18n.defaultLocale = "en_US.UTF-8";
  console = { keyMap = "us"; };
  time.timeZone = "Europe/Berlin";

  age = {
    secrets = {
      home_latitude.file = ../../secrets/home_latitude.age;
      home_longitude.file = ../../secrets/home_latitude.age;
      home_elevation.file = ../../secrets/home_elevation.age;
    };
    identityPaths = [ "/home/${user}/.ssh/id_ed25519" ];
  };
  system.activationScripts."home-assistant-secrets" = ''
    latitude=$(cat "${config.age.secrets.home_latitude.path}")
    longitude=$(cat "${config.age.secrets.home_longitude.path}")
    elevation=$(cat "${config.age.secrets.home_elevation.path}")

    configFile=/home/${user}/dotfiles/nix/.config/nix/modules/home-assistant/default.nix
    ${pkgs.gnused}/bin/sed -i "s#latitude_secret#$latitude#" "$configFile"
    ${pkgs.gnused}/bin/sed -i "s#longitude_secret#$longitude#" "$configFile"
    ${pkgs.gnused}/bin/sed -i "s#elevation_secret#$elevation#" "$configFile"
  '';

  environment.systemPackages = with pkgs; [
    gitMinimal
    magic-wormhole
    neovim
  ];
  # This causes an overlay which causes a lot of rebuilding
  environment.noXlibs = lib.mkForce false;

  nixpkgs.overlays = [
    (final: super: {
      makeModulesClosure = x:
        super.makeModulesClosure (x // { allowMissing = true; });
    })
  ];

  system.stateVersion = "24.05";
}
