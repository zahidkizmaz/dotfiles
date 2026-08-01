{ config, pkgs, ... }:
{
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.nvidia.acceptLicense = true;

  hardware.graphics.enable = true;

  hardware.nvidia = {
    # Modesetting is required for the driver to manage clocks properly.
    modesetting.enable = true;

    # Keep conservative: finegrained (D3 GPU-off when idle) is Turing+ only,
    # and this host never suspends (always-on server).
    powerManagement.enable = false;
    powerManagement.finegrained = false;

    # Proprietary kernel module. `open` is Turing+ only (GM107 can't use it).
    open = false;

    # The nvidia-settings menu is only useful on a desktop; skip on server.
    nvidiaSettings = false;

    # GTX 860M 2GB (Maxwell, GM107)
    # legacy_470 was the old choice but is EOL and no longer builds on the
    # latest kernel (that's what broke the CI build and got this file deleted).
    # NVIDIA moved Maxwell/Pascal/Volta to the 580 legacy branch, which is
    # still maintained for modern kernels.
    package = config.boot.kernelPackages.nvidiaPackages.legacy_580;
  };

  # Load the nvidia kernel module at boot. `hardware.nvidia` is gated on
  # this option (cfg.enabled = videoDrivers contains "nvidia") — without it
  # nothing above takes effect. Headless server: driver loads, X never runs.
  services.xserver.videoDrivers = [ "nvidia" ];

  # GPU monitoring (temps/clocks/power via nvidia-smi)
  environment.systemPackages = with pkgs; [ nvtopPackages.nvidia ];
}
