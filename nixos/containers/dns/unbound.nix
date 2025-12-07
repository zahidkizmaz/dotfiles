{ pkgs, ... }:
let
  port = 5335;
in
{
  users.extraGroups.redis-unbound.members = [ "unbound" ];
  services.unbound = {
    enable = true;
    package = pkgs.unbound-full.override { withRedis = true; };

    settings = {
      server = {
        interface = [ "127.0.0.1" ];
        port = port;
        do-ip4 = "yes";
        do-ip6 = "yes";
        do-udp = "yes";
        do-tcp = "yes";

        root-hints = "${pkgs.dns-root-data}/root.hints";

        qname-minimisation = "yes";
        qname-minimisation-strict = "no";
        ede = "yes";
        hide-identity = "yes";
        hide-version = "yes";

        # Trust anchor for DNSSEC
        auto-trust-anchor-file = "/var/lib/unbound/root.key";
        val-clean-additional = "yes";

        # Reduce DNSSEC strictness to prevent cold start failures
        val-permissive-mode = "yes"; # Don't fail on DNSSEC issues
        harden-dnssec-stripped = "no"; # Less strict for speed
        harden-referral-path = "no"; # Disable for speed
        harden-algo-downgrade = "no"; # Disable for speed

        # Thread/slab config for 4 cores
        num-threads = 4;
        msg-cache-slabs = 4;
        rrset-cache-slabs = 4;
        infra-cache-slabs = 4;
        key-cache-slabs = 4;

        # Large cache sizes
        rrset-cache-size = "512m";
        msg-cache-size = "256m";
        key-cache-size = "128m";
        neg-cache-size = "64m";

        # Large buffers
        so-rcvbuf = "32m";
        so-sndbuf = "32m";

        # More connections
        num-queries-per-thread = 4096;

        # Aggressive prefetching and serving expired
        prefetch = "yes";
        prefetch-key = "yes";
        serve-expired = "yes";
        serve-expired-ttl = 86400;
        serve-expired-ttl-reset = "yes";
        serve-expired-reply-ttl = 30;
        serve-expired-client-timeout = 1800;

        # Aggressive caching
        aggressive-nsec = "yes";
        cache-min-ttl = 60;
        cache-max-ttl = 86400;
        cache-max-negative-ttl = 3600;

        # Increase limits for iterative resolution
        max-sent-count = 128; # Increase from default 32
        max-query-restarts = 16; # Increase from default 11
        outgoing-range = 16384;
        jostle-timeout = 2000; # 2 second timeout
        unknown-server-time-limit = 500; # 500ms per server

        # Network and timeout tuning for cold starts
        infra-host-ttl = 900;
        infra-cache-numhosts = 10000;
        target-fetch-policy = "\"3 2 1 1 1\""; # More conservative fetching

        # Reduce initial RTT timeout issues
        infra-cache-min-rtt = 50; # Minimum 50ms RTT

        # Minimal logging for performance
        verbosity = 1;
        use-syslog = "yes";
        log-queries = "no";
        log-replies = "no";
        log-servfail = "yes"; # Log failures to diagnose issues

        # Access control - only local
        access-control = [
          "127.0.0.0/8 allow"
          "::1 allow"
          "0.0.0.0/0 refuse"
          "::0/0 refuse"
        ];

        # No rate limiting for local use
        ip-ratelimit = 0;
        ratelimit = 0;
        minimal-responses = "yes";

        # EDNS
        edns-buffer-size = 1232;
        max-udp-size = 1232;

        # Security
        unwanted-reply-threshold = 10000000;
        use-caps-for-id = "yes";
        harden-glue = "yes";
        harden-below-nxdomain = "yes";

        private-address = [
          "192.168.0.0/16"
          "169.254.0.0/16"
          "172.16.0.0/12"
          "10.0.0.0/8"
          "fd00::/8"
          "fe80::/10"
        ];

        # Module order with cachedb
        "module-config" = "\"validator cachedb iterator\"";

        # Allow localhost queries
        do-not-query-localhost = "no";
        outgoing-num-tcp = 256;
        incoming-num-tcp = 256;

        # Pre-load popular domains to avoid cold start
        # These get resolved immediately on startup
        local-zone = [
          "localhost. static"
        ];

        # CRITICAL: Ensure we can reach root servers
        do-not-query-address = [ ]; # Don't block any addresses
      };

      # Redis configuration
      cachedb = {
        backend = "redis";
        "redis-server-path" = "/var/run/redis-unbound/redis.sock";
        "redis-timeout" = 500;
        "redis-expire-records" = "yes";
      };

      remote-control = {
        "control-enable" = true;
      };

      forward-zone = [
        {
          name = ".";
          # Quad9 with DNS-over-TLS for privacy and reliability
          forward-addr = [
            "9.9.9.9@853#dns.quad9.net"
            "149.112.112.112@853#dns.quad9.net"
          ];
          forward-tls-upstream = "yes";
          forward-first = "yes"; # Unbound tries forwarding first but falls back to iterative resolution if forwarders fail.
        }
      ];
    };
  };
  systemd.services.unbound.serviceConfig = {
    LimitNOFILE = 65536;
  };

  systemd.services.unbound.after = [ "redis-unbound.service" ];
  systemd.services.unbound.requires = [ "redis-unbound.service" ];
}
