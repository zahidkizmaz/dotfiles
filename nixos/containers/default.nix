{
  config,
  lib,
  pkgs,
  inputs,
  user,
  stateVersion,
  system,
  ...
}:

# NOTE: Do NOT reference config in imports or top-level let bindings
# to avoid infinite recursion. config is safe inside the `config` section only.
# Host-level networking (sysctl, NAT, tailscale) is handled by host-networking.nix.

{
  imports = [
    ./options.nix
    ./backup.nix
    (import ./monitoring/alloy-log-report.nix { })
  ];

  config = lib.mkIf (config.appContainers.enable != [ ]) {
    # Build container definitions dynamically from appContainers config
    containers =
      let
        hostAddress = "192.168.100.10";

        # Map from host config key (filename) to file path and actual NixOS container name
        containerMeta = {
          immich = {
            path = ./immich.nix;
            cname = "immich";
          };
          searx = {
            path = ./searx.nix;
            cname = "search";
          };
          karakeep = {
            path = ./karakeep.nix;
            cname = "keep";
          };
          stirling-pdf = {
            path = ./stirling-pdf.nix;
            cname = "pdf";
          };
          navidrome = {
            path = ./navidrome.nix;
            cname = "music";
          };
          paperless = {
            path = ./paperless.nix;
            cname = "paperless";
          };
          mealie = {
            path = ./mealie.nix;
            cname = "meal";
          };
          ntfy = {
            path = ./ntfy.nix;
            cname = "ntfy";
          };
          uptime-kuma = {
            path = ./uptime-kuma.nix;
            cname = "status";
          };
          watch = {
            path = ./watch.nix;
            cname = "watch";
          };
          trilium = {
            path = ./trilium.nix;
            cname = "notes";
          };
          dns = {
            path = ./dns/dns.nix;
            cname = "dns";
          };
          monitoring = {
            path = ./monitoring/grafana.nix;
            cname = "monitoring";
          };
        };

        enabledContainers = lib.filterAttrs (
          n: _: lib.elem n config.appContainers.enable
        ) config.appContainers.containers;
      in
      lib.mapAttrs (
        name: containerCfg:
        let
          meta = containerMeta.${name} or (throw "Unknown container: ${name}");
          mod = import meta.path {
            inherit
              stateVersion
              inputs
              user
              hostAddress
              ;
            localAddress = containerCfg.localAddress;
          };
        in
        mod.containers.${meta.cname}
      ) enabledContainers;
  };
}
