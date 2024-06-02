{ lib, pkgs, user, ... }:
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

  # At the moment not used
  # age = {
  #   secrets = {
  #     home_latitude.file = ../../secrets/home_latitude.age;
  #     home_longitude.file = ../../secrets/home_latitude.age;
  #     home_elevation.file = ../../secrets/home_elevation.age;
  #   };
  #   identityPaths = [ "/home/${user}/.ssh/id_ed25519" ];
  # };

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
