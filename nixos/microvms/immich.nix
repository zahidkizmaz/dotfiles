{ config, stateVersion, ... }:
{
  microvm.vms = {
    immich-microvm = {
      autostart = true;
      # The configuration for the MicroVM.
      # Multiple definitions will be merged as expected.
      config = {
        # It is highly recommended to share the host's nix-store
        # with the VMs to prevent building huge images.
        microvm = {
          qemu = {
            extraArgs = [
              "-serial"
              "unix:1337,server,nowait"
            ];
            serialConsole = false;
          };
          vcpu = 4;
          mem = 4096;
          interfaces = [
            {
              type = "user";
              id = "vm-a1";
              mac = "02:00:00:00:00:01";
            }
          ];
          forwardPorts = [
            {
              from = "host";
              host.port = 2222;
              guest.port = 22;
            }
          ];
          shares = [
            {
              source = "/nix/store";
              mountPoint = "/nix/.ro-store";
              tag = "ro-store";
              proto = "virtiofs";
            }
          ];
        };

        imports = [
          ./vm-user.nix
          ../modules/bootloader-systemd.nix
        ];
        boot.kernelParams = [
          "console=ttyS0,38400n8"
          "earlyprint=serial,ttyS0,38400n8"
        ];
        networking.useNetworkd = true;
        services = {
          tailscale = {
            enable = true;
            authKeyFile = config.age.secrets."tailscale-lab".path;
          };
          immich = {
            enable = true;
            port = 2283;
          };
        };
        system.stateVersion = stateVersion;
      };
    };
  };
}
