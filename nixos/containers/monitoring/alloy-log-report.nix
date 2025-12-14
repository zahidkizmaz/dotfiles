{
  lokiUrl ? "https://monitoring.quoll-ratio.ts.net:3100",
  prometheusUrl ? "https://monitoring.quoll-ratio.ts.net:9090",
  ...
}:
let
  configText = ''
    // SECTION: TARGETS

    loki.write "default" {
    	endpoint {
    		url = "${lokiUrl}/loki/api/v1/push"
    	}
    	external_labels = {}
    }

    prometheus.remote_write "default" {
      endpoint {
        url = "${prometheusUrl}/api/v1/write"
      }
    }

    // SECTION: SYSTEM LOGS & JOURNAL

    loki.source.journal "journal" {
      max_age       = "720h0m0s"
      relabel_rules = discovery.relabel.journal.rules
      forward_to    = [loki.write.default.receiver]
      labels        = {component = string.format("%s-journal", constants.hostname)}
    }

    local.file_match "system" {
      path_targets = [{
        __address__ = "localhost",
        __path__    = "/var/log/{syslog,messages,*.log}",
        instance    = constants.hostname,
        job         = string.format("%s-logs", constants.hostname),
      }]
    }

    discovery.relabel "journal" {
      targets = []
      rule {
        source_labels = ["__journal__systemd_unit"]
        target_label  = "unit"
      }
      rule {
        source_labels = ["__journal__boot_id"]
        target_label  = "boot_id"
      }
      rule {
        source_labels = ["__journal__transport"]
        target_label  = "transport"
      }
      rule {
        source_labels = ["__journal_priority_keyword"]
        target_label  = "level"
      }
      rule {
        source_labels = ["__journal__machine_id"]
        target_label  = "machine_id"
      }
      rule {
        source_labels = ["__journal_container_name"]
        target_label  = "container"
      }
    }

    loki.source.file "system" {
      targets    = local.file_match.system.targets
      forward_to = [loki.write.default.receiver]
    }

    // SECTION: SYSTEM METRICS

    discovery.relabel "metrics" {
      targets = prometheus.exporter.unix.metrics.targets
      rule {
        target_label = "instance"
        replacement  = constants.hostname
      }
      rule {
        target_label = "job"
        replacement = string.format("%s-metrics", constants.hostname)
      }
    }

    prometheus.exporter.unix "metrics" {
      disable_collectors = ["ipvs", "btrfs", "infiniband", "xfs", "zfs"]
      enable_collectors = ["meminfo"]
      filesystem {
        fs_types_exclude     = "^(autofs|binfmt_misc|bpf|cgroup2?|configfs|debugfs|devpts|devtmpfs|tmpfs|fusectl|hugetlbfs|iso9660|mqueue|nsfs|overlay|proc|procfs|pstore|rpc_pipefs|securityfs|selinuxfs|squashfs|sysfs|tracefs)$"
        mount_points_exclude = "^/(dev|proc|run/credentials/.+|sys|var/lib/docker/.+)($|/)"
        mount_timeout        = "5s"
      }
      netclass {
        ignored_devices = "^(veth.*|cali.*|[a-f0-9]{15})$"
      }
      netdev {
        device_exclude = "^(veth.*|cali.*|[a-f0-9]{15})$"
      }
    }

    prometheus.scrape "metrics" {
    scrape_interval = "15s"
      targets    = discovery.relabel.metrics.output
      forward_to = [prometheus.remote_write.default.receiver]
    }
  '';
in
{
  services.alloy = {
    enable = true;
    extraFlags = [ "--disable-reporting" ];
  };
  environment.etc."alloy/config.alloy".text = configText;
}
