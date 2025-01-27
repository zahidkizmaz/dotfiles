{
  pkgs,
  lib,
  system,
  config,
  ...
}:
{
  nixpkgs.hostPlatform = lib.mkDefault system;
  system = {
    stateVersion = 5;

    keyboard = {
      enableKeyMapping = true;
      swapLeftCtrlAndFn = true;
      remapCapsLockToEscape = true;
    };
    defaults = {
      controlcenter = {
        BatteryShowPercentage = true;
      };
      trackpad = {
        Clicking = true;
        TrackpadRightClick = true;
        TrackpadThreeFingerDrag = true;
      };
      NSGlobalDomain = {
        KeyRepeat = 9;
        InitialKeyRepeat = 5;
      };
      dock = {
        autohide = true;
      };
    };
  };

  # Make nix daemon work
  programs = {
    zsh = {
      shellInit = ''
        [[ -e "/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh" ]] && source "/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh"
      '';
    };
  };

  # Make nix installed applications appear on Spotlight
  system.activationScripts.postUserActivation.text = ''
    apps_source="${config.system.build.applications}/Applications"
    moniker="Nix Trampolines"
    app_target_base="$HOME/Applications"
    app_target="$app_target_base/$moniker"
    mkdir -p "$app_target"
    ${pkgs.rsync}/bin/rsync --archive --checksum --chmod=-w --copy-unsafe-links --delete "$apps_source/" "$app_target"
  '';
}
