# Filesystem-level tuning for the btrfs root.
#
# The root is a single btrfs volume with `compress=zstd:1` and CoW enabled (see
# disko.nix). That is a fine default for the nix store (large, read-mostly,
# highly compressible) but a bad one for two write-heavy workloads:
#
#   * Browser caches — constant small, overwrite-heavy writes of data that is
#     already compressed. Every write pays CoW + checksum + zstd + a
#     transaction commit. During video playback this made btrfs commit_work and
#     btrfs_work_helper the top two CPU consumers (~10 W for a ~10.5 W CPU).
#   * VM / container images — random writes inside a single file, which
#     fragment badly under CoW and cause multi-second CPU spikes.
#
# So:
#   1. Browser caches are mounted on tmpfs — they never touch the disk at all.
#   2. VM/container image directories get the NOCOW attribute, so newly created
#      files skip CoW (and with it compression and checksums).
#
# Neither change requires re-running disko; only disko's mountOptions feed into
# /etc/fstab, and fileSystems entries here are plain NixOS options.
{
  pkgs,
  user,
  config,
  ...
}:
let
  # Not config.users.users.${user}.home — fileSystems is part of config, and
  # referencing config from a fileSystems definition recurses infinitely.
  home = "/home/${user}";

  uid = config.users.users.${user}.uid;
  gid = config.users.groups.${config.users.users.${user}.group}.gid;

  # Disposable, so losing them on reboot is fine. 2 GiB each is ample; the
  # browser just evicts when it fills.
  browserCacheDirs = [
    "zen"
    "mozilla"
    "BraveSoftware"
  ];

  # Random-write-heavy image stores. Keep in sync with the libvirt / podman
  # modules.
  imageDirs = [
    "/var/lib/libvirt/images"
    "/var/lib/containers/storage"
  ];
in
{
  # =========================================================================
  # 1. Browser caches -> tmpfs (RAM), zero disk writes.
  # =========================================================================
  fileSystems = builtins.listToAttrs (
    map (d: {
      name = "${home}/.cache/${d}";
      value = {
        device = "tmpfs";
        fsType = "tmpfs";
        options = [
          "size=2G"
          "mode=0700"
          "uid=${toString uid}"
          "gid=${toString gid}"
          "noatime"
        ];
      };
    }) browserCacheDirs
  );

  # =========================================================================
  # 2. VM/container image dirs -> NOCOW.
  # =========================================================================
  # `chattr +C` on a directory is inherited by files created afterwards;
  # existing images are not converted (only new ones are). NOCOW also disables
  # checksums and compression for those files — acceptable for image stores,
  # which are recreatable/backed up elsewhere.
  systemd.services.nodatacow-images = {
    description = "Disable CoW for VM/container image directories";
    wantedBy = [ "multi-user.target" ];
    # Only .service units here: ordering before a .socket would cycle through
    # sockets.target -> basic.target. Containers/VMs create their files from the
    # services anyway, and those start on demand after boot, so plain service
    # ordering is enough.
    before = [
      "libvirtd.service"
      "podman.service"
    ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };
    script = ''
      for d in ${builtins.concatStringsSep " " imageDirs}; do
        if [ -d "$d" ]; then
          ${pkgs.e2fsprogs.bin}/bin/chattr +C "$d" || true
        fi
      done
    '';
  };
}
