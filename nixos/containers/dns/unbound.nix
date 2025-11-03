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

        qname-minimisation = "yes";
        qname-minimisation-strict = "no";
        ede = "yes";
        hide-identity = "yes";
        hide-version = "yes";

        auto-trust-anchor-file = "/var/lib/unbound/root.key";
        val-clean-additional = "yes";

        num-threads = 4;
        msg-cache-slabs = 4;
        rrset-cache-slabs = 4;
        infra-cache-slabs = 4;
        key-cache-slabs = 4;

        rrset-cache-size = "512m";
        msg-cache-size = "256m";
        key-cache-size = "128m";
        neg-cache-size = "64m";

        so-rcvbuf = "32m";
        so-sndbuf = "32m";

        outgoing-range = 8192;
        num-queries-per-thread = 4096;

        prefetch = "yes";
        prefetch-key = "yes";

        serve-expired = "yes";
        serve-expired-ttl = 86400;
        serve-expired-ttl-reset = "yes";
        serve-expired-reply-ttl = 30;
        serve-expired-client-timeout = 1800;

        aggressive-nsec = "yes";
        cache-min-ttl = 60; # Minimum 1 minute cache
        cache-max-ttl = 86400; # Maximum 24 hour cache
        cache-max-negative-ttl = 3600; # Cache NXDOMAIN for 1 hour

        # OPTIMIZED: Reduce latency
        infra-host-ttl = 900; # 15 minutes
        infra-cache-numhosts = 10000;
        jostle-timeout = 200; # Drop slow queries faster
        target-fetch-policy = "\"3 2 1 0 0\""; # More aggressive fetching

        verbosity = 1;
        use-syslog = "yes";
        log-queries = "no";

        access-control = [
          "127.0.0.0/8 allow"
          "::1 allow"
          "0.0.0.0/0 refuse"
          "::0/0 refuse"
        ];

        ip-ratelimit = 0;
        ratelimit = 0;
        minimal-responses = "yes";

        edns-buffer-size = 1232;
        max-udp-size = 1232;

        # Security
        unwanted-reply-threshold = 10000000;
        use-caps-for-id = "yes";
        harden-glue = "yes";
        harden-dnssec-stripped = "yes";
        harden-below-nxdomain = "yes";
        harden-referral-path = "no";
        harden-algo-downgrade = "no";

        do-not-query-localhost = "no"; # Allow queries to localhost
        outgoing-num-tcp = 256; # More TCP connections
        incoming-num-tcp = 256;

        private-address = [
          "192.168.0.0/16"
          "169.254.0.0/16"
          "172.16.0.0/12"
          "10.0.0.0/8"
          "fd00::/8"
          "fe80::/10"
        ];

        "module-config" = "\"validator cachedb iterator\"";
      };
      cachedb = {
        backend = "redis";
        "redis-server-path" = "/var/run/redis-unbound/redis.sock";
        "redis-timeout" = 10;
        "redis-expire-records" = true;
      };
      "remote-control" = {
        "control-enable" = true;
      };
    };
  };
  systemd.services.unbound.serviceConfig = {
    LimitNOFILE = 65536;
  };

  systemd.services.unbound.after = [ "redis-unbound.service" ];
  systemd.services.unbound.requires = [ "redis-unbound.service" ];
}
