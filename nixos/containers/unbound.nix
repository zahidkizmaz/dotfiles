{ ... }:

{
  imports = [ ./settings.nix ];

  containers.unbound = {
    autoStart = true;

    bindMounts = {
      "/var/log/redis.log" = {
        hostPath = "/tmp/redis-log/redis.log";
        isReadOnly = false;
      };
      "/var/log/unbound.log" = {
        hostPath = "/tmp/unbound-log/unbound.log";
        isReadOnly = false;
      };
      "/var/lib/redis-redis-unbound" = {
        hostPath = "/tmp/redis";
        isReadOnly = false;
      };
    };

    config = { lib, ... }: {
      services.redis.vmOverCommit = true;
      services.redis.servers.redis-unbound = {
        enable = true;
        port = 6379;
        logfile = "/var/log/redis.log";
      };
      services.unbound = {
        enable = true;
        settings = {
          server = {
            interface = "127.0.0.1";
            access-control = [ "127.0.0.0/8 allow" ];
            port = 5354;
            do-ip4 = true;
            do-udp = true;
            do-tcp = true;
            do-ip6 = false;

            do-not-query-localhost = false;

            # Logging
            logfile = "/var/log/unbound.log";
            verbosity = 1;
            log-queries = false;

            # Trust glue only if it is within the server's authority
            harden-glue = true;

            # Require DNSSEC data for trust-anchored zones, if such data is absent, the zone becomes BOGUS
            harden-dnssec-stripped = true;

            # Don't use Capitalization randomization as it known to cause DNSSEC issues sometimes
            # see https://discourse.pi-hole.net/t/unbound-stubby-or-dnscrypt-proxy/9378 for further details
            use-caps-for-id = false;

            # Reduce EDNS reassembly buffer size.
            # IP fragmentation is unreliable on the Internet today, and can cause
            # transmission failures when large DNS messages are sent via UDP. Even
            # when fragmentation does work, it may not be secure; it is theoretically
            # possible to spoof parts of a fragmented DNS message, without easy
            # detection at the receiving end. Recently, there was an excellent study
            # >>> Defragmenting DNS - Determining the optimal maximum UDP response size for DNS <<<
            # by Axel Koolhaas, and Tjeerd Slokker (https://indico.dns-oarc.net/event/36/contributions/776/)
            # in collaboration with NLnet Labs explored DNS using real world data from the
            # the RIPE Atlas probes and the researchers suggested different values for
            # IPv4 and IPv6 and in different scenarios. They advise that servers should
            # be configured to limit DNS messages sent over UDP to a size that will not
            # trigger fragmentation on typical network links. DNS servers can switch
            # from UDP to TCP when a DNS response is too big to fit in this limited
            # buffer size. This value has also been suggested in DNS Flag Day 2020.
            edns-buffer-size = 1232;

            # Ensure kernel buffer is large enough to not lose messages in traffic spikes
            so-rcvbuf = "4m";
            so-sndbuf = "4m";


            # |Privacy|
            # Deny queries of type ANY with an empty response
            deny-any = true;
            # Set the total number of unwanted replies to keep track of in every thread.
            # If it reaches the threshold, warning is printed and a defensive action is
            # taken, cache is cleared to flush away any poison
            # Suggested value is 10000000, default is 0 (turned off)
            unwanted-reply-threshold = 10000;
            # Rotates RRSet order in response (the pseudo-random number is taken from
            # the query ID, for speed and thread safety)
            rrset-roundrobin = true;
            # Send minimum amount of information to upstream servers to enhance privacy
            qname-minimisation = true;
            # Do no insert authority/additional sections into response messages when
            # those sections are not required. This reduces response size significantly
            # and may avoid TCP fallback for some responses. It may speedup slightly.
            minimal-responses = true;
            # Refuse id.server and hostname.bind queries
            hide-identity = true;
            # Report this identity rather than the hostname of the server.
            identity = "DNS";
            hide-version = true;

            # |Performance|
            num-threads = 4;
            so-reuseport = true;

            # |Cache|
            # Slabs reduce lock contention by threads. Set to power of 2, close to num-threads
            msg-cache-slabs = 4;
            rrset-cache-slabs = 4;
            infra-cache-slabs = 4;
            key-cache-slabs = 4;
            # rrset-cache-size should be twice of msg-cache-size
            msg-cache-size = "128m";
            rrset-cache-size = "256m";
            # Time to live minimum for messages in cache. More than an hour could easily
            # give trouble due to stale data. Default is 0
            cache-min-ttl = 10;
            # I prefer to have the latest 'hot' data
            cache-max-ttl = 21600;
            # infra-host-ttl= 900
            # Number of bytes size of the aggressive negative cache
            neg-cache-size = "4m";
            # Perform prefetching of almost expired message cache entries
            prefetch = true;
            # Fetch the DNSKEYs earlier in the validation process, when a DS record is
            # encountered. This lowers the latency of requests at the expense of little
            # more CPU usage.
            prefetch-key = true;
            # Have unbound attempt to serve old responses from cache with a TTL of 0 in
            # the response without waiting for the actual resolution to finish. The
            # actual resolution answer ends up in the cache later on.
            serve-expired = true;
            # TTL value to use when replying with expired data. If serve-expired-client-timeout
            # is used then recommended to use 30. Default is 30
            # Added for cachedb warning at unbound start. Unbound sets it to 0 for records
            # originating from cachedb
            serve-expired-reply-ttl = 30;
          };
          # redis cache
          cachedb = {
            backend = "redis";
            redis-expire-records = false;
          };
          forward-zone = [
            {
              name = ".";
              forward-addr = [
                "9.9.9.9#dns.quad9.net"
                "149.112.112.112#dns.quad9.net"
              ];
              forward-tls-upstream = true; # Protected DNS
            }
          ];
        };
      };
      networking = {
        firewall = {
          enable = true;
          allowedTCPPorts = [ 5354 ];
        };
        # Use systemd-resolved inside the container
        # Workaround for bug https://github.com/NixOS/nixpkgs/issues/162686
        useHostResolvConf = lib.mkForce false;
      };

      system.stateVersion = "24.05";
    };
  };
}
