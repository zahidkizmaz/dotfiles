{
  serviceName,
  lokiUrl ? "https://monitoring.quoll-ratio.ts.net:3100",
  ...
}:
let
  configText = ''
    loki.source.journal "systemd-journal-logs" {
      forward_to = [ loki.write.default.receiver ]

      # Labels to apply to all logs from this source
      labels = {
        job = "systemd-journal"
      }

      # Filter logs with systemd journal match syntax to specific services
      matches = "_SYSTEMD_UNIT=${serviceName}.service"
    }

    loki.write "default" {
      endpoint {
        url = "${lokiUrl}/loki/api/v1/push"
      }
    }
  '';
in
{
  services.alloy = {
    enable = true;
  };
  environment.etc."alloy/config.alloy".text = configText;
}
