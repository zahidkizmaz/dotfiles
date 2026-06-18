{
  config,
  lib,
  inputs,
  user,
  stateVersion,
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

  config = lib.mkIf config.appContainers.enable {
    # Build container definitions dynamically from appContainers config
    containers =
      let
        hostAddress = "192.168.100.10";

        # Central mapping: host config key -> file path, internal container name, and IP
        containerMeta = {
          immich = {
            path = ./immich.nix;
            cname = "immich";
            ip = "192.168.100.11";
          };
          searx = {
            path = ./searx.nix;
            cname = "search";
            ip = "192.168.100.13";
          };
          karakeep = {
            path = ./karakeep.nix;
            cname = "keep";
            ip = "192.168.100.14";
          };
          stirling-pdf = {
            path = ./stirling-pdf.nix;
            cname = "pdf";
            ip = "192.168.100.15";
          };
          navidrome = {
            path = ./navidrome.nix;
            cname = "music";
            ip = "192.168.100.16";
          };
          paperless = {
            path = ./paperless.nix;
            cname = "paperless";
            ip = "192.168.100.18";
          };
          mealie = {
            path = ./mealie.nix;
            cname = "meal";
            ip = "192.168.100.19";
          };
          ntfy = {
            path = ./ntfy.nix;
            cname = "ntfy";
            ip = "192.168.100.20";
          };
          uptime-kuma = {
            path = ./uptime-kuma.nix;
            cname = "status";
            ip = "192.168.100.21";
          };
          watch = {
            path = ./watch.nix;
            cname = "watch";
            ip = "192.168.100.23";
          };
          trilium = {
            path = ./trilium.nix;
            cname = "notes";
            ip = "192.168.100.24";
          };
          dns = {
            path = ./dns/dns.nix;
            cname = "dns";
            ip = "192.168.100.22";
          };
          monitoring = {
            path = ./monitoring/grafana.nix;
            cname = "monitoring";
            ip = "192.168.100.17";
          };
          ollama = {
            path = ./ollama.nix;
            cname = "ollama";
            ip = "192.168.100.25";
          };
          hermes-agent = {
            path = ./hermes-agent.nix;
            cname = "hermes";
            ip = "192.168.100.26";
          };
        };

        enabledContainers = lib.filterAttrs (_: c: c.enable) config.appContainers.containers;
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
            localAddress = meta.ip;
            models = containerCfg.models;
          };
        in
        mod.containers.${meta.cname}
        // lib.optionalAttrs (containerCfg.hostname != "") {
          config = {
            imports = [
              mod.containers.${meta.cname}.config
              { networking.hostName = lib.mkForce containerCfg.hostname; }
            ];
          };
        }
      ) enabledContainers;
  };
}
