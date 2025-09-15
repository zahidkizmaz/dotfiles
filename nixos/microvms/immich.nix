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
          vcpu = 4;
          mem = 4096;
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
