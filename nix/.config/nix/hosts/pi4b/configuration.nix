{ pkgs, user, ... }:
{
  hardware = {
    bluetooth.enable = false;
    bluetooth.powerOnBoot = false;
  };
  networking = {
    hostName = "pi4b";
    networkmanager.enable = false;
    interfaces.eth0.ipv4.addresses = [{
      address = "192.168.178.24";
      prefixLength = 24;
    }];
    wireless.enable = false;

    firewall.enable = true;
    firewall.allowedTCPPorts = [ 22 443 ];
  };

  users.users.${user} = {
    isNormalUser = true;
    shell = pkgs.zsh;
    extraGroups = [ "networkmanager" "input" "wheel" "video" "audio" "storage" ];
  };
  programs = {
    zsh = {
      enable = true;
      autosuggestions.enable = true;
      syntaxHighlighting.enable = true;
    };
    starship.enable = true;
  };

  fonts.packages = with pkgs; [
    fira-code-nerdfont
    noto-fonts-color-emoji
  ];

  i18n.defaultLocale = "en_US.UTF-8";
  console = { keyMap = "us"; };
  time.timeZone = "Europe/Berlin";

  environment.systemPackages = with pkgs; [
    gitMinimal
    magic-wormhole
    neovim
  ];

  # Limit update size/frequency of rebuilds
  # Also preserve space on SD card
  documentation.nixos.enable = false;

  nixpkgs.overlays = [
    (final: super: {
      makeModulesClosure = x:
        super.makeModulesClosure (x // { allowMissing = true; });
    })
  ];

  system.stateVersion = "24.05";
}
