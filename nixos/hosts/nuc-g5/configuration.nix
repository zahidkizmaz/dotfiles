{
  config,
  pkgs,
  lib,
  modulesPath,
  stateVersion,
  ...
}:
{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.kernelModules = [ "kvm-intel" ];
  boot.initrd.availableKernelModules = [
    "xhci_pci"
    "ahci"
    "usbhid"
    "sd_mod"
  ];
  boot.initrd.kernelModules = [ ];
  boot.extraModulePackages = [ ];
  boot.kernel.sysctl = {
    "net.core.wmem_max" = 16777216; # needed for unbound
    "net.core.rmem_max" = 16777216; # needed for unbound
  };

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

  swapDevices = [
    {
      device = "/var/lib/swapfile";
      size = 32 * 1024; # 32GB
    }
  ];

  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      intel-media-driver # LIBVA_DRIVER_NAME=iHD
      intel-vaapi-driver # LIBVA_DRIVER_NAME=i965 (older but works better for Firefox/Chromium)
      libvdpau-va-gl
    ];
  };

  console = {
    keyMap = "us";
  };
  i18n.defaultLocale = "en_US.UTF-8";
  time.timeZone = "Europe/Berlin";
  networking = {
    hostName = "nuc-g5";
    useDHCP = lib.mkDefault true;
    wireless.enable = false;
    firewall.enable = true;
  };
  services.resolved.enable = true;

  nix.settings.trusted-users = [ "@wheel" ];

  # Host networking (NAT + host tailscale) - SAME as before
  hostNetworking = {
    enable = true;
    externalInterface = "enp2s0";
    tailscaleAuthKey = config.age.secrets.tailscale-lab.path;
  };

  # EXACT same containers with EXACT same IPs
  appContainers.enable = [
    "immich"
    "searx"
    "karakeep"
    "stirling-pdf"
    "navidrome"
    "monitoring"
    "paperless"
    "mealie"
    "ntfy"
    "uptime-kuma"
    "dns"
    "watch"
    "trilium"
  ];
  appContainers.containers = {
    immich = {
      localAddress = "192.168.100.11";
    };
    searx = {
      localAddress = "192.168.100.13";
    };
    karakeep = {
      localAddress = "192.168.100.14";
    };
    stirling-pdf = {
      localAddress = "192.168.100.15";
    };
    navidrome = {
      localAddress = "192.168.100.16";
    };
    monitoring = {
      localAddress = "192.168.100.17";
    };
    paperless = {
      localAddress = "192.168.100.18";
    };
    mealie = {
      localAddress = "192.168.100.19";
    };
    ntfy = {
      localAddress = "192.168.100.20";
    };
    uptime-kuma = {
      localAddress = "192.168.100.21";
    };
    dns = {
      localAddress = "192.168.100.22";
    };
    watch = {
      localAddress = "192.168.100.23";
    };
    trilium = {
      localAddress = "192.168.100.24";
    };
  };

  # Backup with multiple targets (local drive + filen remote)
  appContainers.backup = {
    enable = true;
    resticPassword = config.age.secrets.restic-password.path;
    targets = [
      {
        name = "local";
        type = "local";
        enabled = true;
        mountPath = "/backup";
        device = "/dev/disk/by-label/backup-drive";
        fsType = "btrfs";
        mountOptions = [
          "defaults"
          "noatime"
          "nofail"
          "compress=zstd"
        ];
        schedule = "03:00";
        prune = [ "--keep-daily 3" ];
      }
      {
        name = "filen";
        type = "rclone";
        enabled = true;
        rcloneConfig = config.age.secrets.rclone-config-filen.path;
        remotePath = "filen-backend:backups/";
        schedule = "Fri *-*-* 04:30:00";
        prune = [ "--keep-weekly 3" ];
      }
    ];
    containers = [
      {
        name = "immich";
        containerPath = "/var/lib/immich";
        backupFolderName = "immich";
      }
      {
        name = "notes";
        containerPath = "/var/lib/trilium";
        backupFolderName = "trilium";
      }
      {
        name = "paperless";
        containerPath = "/var/lib/paperless/export";
        backupFolderName = "paperless";
      }
      {
        name = "meal";
        containerPath = "/var/lib/private/mealie";
        backupFolderName = "mealie";
      }
      {
        name = "status";
        containerPath = "/var/lib/private/uptime-kuma";
        backupFolderName = "uptime-kuma";
      }
      {
        name = "keep";
        containerPath = "/var/lib/karakeep";
        backupFolderName = "karakeep";
      }
      {
        name = "monitoring";
        containerPath = "/var/lib/grafana/data";
        backupFolderName = "grafana";
      }
    ];
  };

  system.stateVersion = stateVersion;
}
