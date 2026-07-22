{
  stateVersion,
  localAddress,
  hostAddress,
  inputs,
  user,
  ...
}:
let
  containerName = "books";
  calibreWebPort = 8083;
  calibreServerPort = 8080;
  libraryPath = "/var/lib/calibre-server";
in
{
  containers.${containerName} = {
    autoStart = true;
    privateNetwork = true;
    privateUsers = "identity";
    enableTun = true;
    ephemeral = false;
    hostAddress = hostAddress;
    localAddress = localAddress;
    bindMounts = {
      "/etc/ssh/lab" = {
        hostPath = "/home/${user}/.ssh/lab";
        isReadOnly = true;
      };
      "/mnt/books" = {
        hostPath = "/home/${user}/books";
        isReadOnly = false;
      };
    };
    config =
      {
        config,
        pkgs,
        lib,
        ...
      }:
      {
        imports = [
          ./container-common.nix
          (import ./container-tailscale.nix {
            inherit
              config
              inputs
              lib
              pkgs
              ;
            port = calibreWebPort;
          })
        ];

        # calibre-web needs write access to the library (for uploads etc.)
        users.users.calibre-web.extraGroups = [ "calibre-server" ];

        systemd.services.calibre-server.preStart = ''
          ${pkgs.calibre}/bin/calibredb --with-library ${libraryPath} list --limit 1
          chmod 0775 ${libraryPath}
          chmod 0664 ${libraryPath}/metadata.db 2>/dev/null || true
        '';

        services.calibre-server = {
          enable = true;
          port = calibreServerPort;
          host = "0.0.0.0";
          libraries = [ libraryPath ];
        };

        services.calibre-web = {
          enable = true;
          listen = {
            ip = "0.0.0.0";
            port = calibreWebPort;
          };
          options = {
            calibreLibrary = libraryPath;
            enableBookUploading = true;
            enableBookConversion = true;
          };
        };

        system.stateVersion = stateVersion;
      };
  };
}
