{ ... }:
{
  services.redis.servers = {
    unbound = {
      enable = true;
      port = 0;

      # OPTIMIZED: Performance settings
      bind = null; # Not needed for Unix socket
      logLevel = "notice";
      databases = 1;

      settings = {
        # OPTIMIZED: Memory and persistence settings
        maxmemory = 2147483648; # 2GB in bytes
        maxmemory-policy = "allkeys-lru";

        # OPTIMIZED: Disable persistence for speed (DNS cache can rebuild)
        save = [ ]; # No RDB snapshots
        appendOnly = false; # No AOF

        # Faster performance
        tcp-backlog = 511;
        timeout = 300;
        tcp-keepalive = 300;

        # Disable slow operations
        slowlog-log-slower-than = 10000; # 10ms
        slowlog-max-len = 128;

        # Optimize for speed
        lazyfree-lazy-eviction = "yes";
        lazyfree-lazy-expire = "yes";
        lazyfree-lazy-server-del = "yes";
        replica-lazy-flush = "yes";

        # Memory optimization
        activerehashing = "yes";

        # Client output buffer limits (prevent slow clients from causing issues)
        client-output-buffer-limit = [
          "normal 0 0 0"
          "replica 256mb 64mb 60"
          "pubsub 32mb 8mb 60"
        ];
      };
    };
  };
}
