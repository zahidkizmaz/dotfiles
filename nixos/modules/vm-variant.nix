{ ... }:
{
  virtualisation.vmVariant = {
    # following configuration is added only when building VM with build-vm
    virtualisation = {
      diskSize = 10000; # disk size in MiB (about 10GB)
      memorySize = 8192; # in MB
      cores = 4;
    };
  };
}
