{
  stateVersion,
  localAddress,
  hostAddress,
  inputs,
  user,
  ...
}:
let
  containerName = "dns";
  port = 3000;
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
          ../container-common.nix
          (import ../container-tailscale.nix {
            inherit
              config
              inputs
              lib
              pkgs
              port
              ;
          })
          ./unbound.nix
          ./redis.nix
        ];

        networking = {
          firewall = {
            allowedTCPPorts = [ 443 ];
            allowedUDPPorts = [ 53 ];
          };
        };

        services = {
          resolved = {
            extraConfig = ''
              [Resolve]
              DNSStubListener=no
            '';
          };
          adguardhome = {
            enable = true;
            mutableSettings = false;
            openFirewall = true;
            settings = {
              pprof = {
                port = 6060;
                enabled = false;
              };
              address = "0.0.0.0:80";
              session_ttl = "720h";

              users = [
                {
                  name = "zahid";
                  password = "$2a$10$p/rG.jVCSuFpe9a8KieV2e6Fi3fqEcF.JelI5FhjN88EiNPFNLRrm";
                }
              ];

              auth_attempts = 5;
              block_auth_min = 15;
              http_proxy = "";
              language = "";
              theme = "dark";

              dns = {
                bind_hosts = [ "0.0.0.0" ];
                port = 53;
                anonymize_client_ip = false;
                ratelimit = 0;
                ratelimit_subnet_len_ipv4 = 24;
                ratelimit_subnet_len_ipv6 = 56;
                ratelimit_whitelist = [ ];
                refuse_any = true;
                upstream_dns = [ "127.0.0.1:5335" ];
                upstream_dns_file = "";
                bootstrap_dns = [
                  "9.9.9.10"
                  "149.112.112.10"
                  "2620:fe::10"
                  "2620:fe::fe:10"
                ];
                fallback_dns = [ ];
                upstream_mode = "parallel";
                fastest_timeout = "500ms";
                allowed_clients = [ ];
                disallowed_clients = [ ];
                blocked_hosts = [
                  "version.bind"
                  "id.server"
                  "hostname.bind"
                ];
                trusted_proxies = [
                  "127.0.0.0/8"
                  "::1/128"
                ];
                cache_size = 67108864;
                cache_ttl_min = 60;
                cache_ttl_max = 86400;
                cache_optimistic = true;
                bogus_nxdomain = [ ];
                aaaa_disabled = false;
                enable_dnssec = false;
                edns_client_subnet = {
                  custom_ip = "";
                  enabled = false;
                  use_custom = false;
                };
                max_goroutines = 300;
                handle_ddr = true;
                ipset = [ ];
                ipset_file = "";
                bootstrap_prefer_ipv6 = false;
                upstream_timeout = "2s";
                private_networks = [ ];
                use_private_ptr_resolvers = true;
                local_ptr_upstreams = [ ];
                use_dns64 = false;
                dns64_prefixes = [ ];
                serve_http3 = false;
                use_http3_upstreams = false;
                serve_plain_dns = true;
                hostsfile_enabled = true;
                pending_requests = {
                  enabled = true;
                };
              };

              tls = {
                enabled = false;
                server_name = "";
                force_https = false;
                port_https = 443;
                port_dns_over_tls = 853;
                port_dns_over_quic = 853;
                port_dnscrypt = 0;
                dnscrypt_config_file = "";
                allow_unencrypted_doh = false;
                certificate_chain = "";
                private_key = "";
                certificate_path = "";
                private_key_path = "";
                strict_sni_check = false;
              };

              querylog = {
                dir_path = "";
                ignored = [ ];
                interval = "2160h";
                size_memory = 1000;
                enabled = true;
                file_enabled = true;
              };

              statistics = {
                dir_path = "";
                ignored = [ ];
                interval = "24h";
                enabled = true;
              };

              filters = [
                {
                  enabled = true;
                  url = "https://adguardteam.github.io/HostlistsRegistry/assets/filter_1.txt";
                  name = "AdGuard DNS filter";
                  id = 1;
                }
                {
                  enabled = true;
                  url = "https://adguardteam.github.io/HostlistsRegistry/assets/filter_59.txt";
                  name = "AdGuard DNS Popup Hosts filter";
                  id = 1759564897;
                }
                {
                  enabled = true;
                  url = "https://adguardteam.github.io/HostlistsRegistry/assets/filter_48.txt";
                  name = "HaGeZi's Pro Blocklist";
                  id = 1759564898;
                }
                {
                  enabled = true;
                  url = "https://adguardteam.github.io/HostlistsRegistry/assets/filter_33.txt";
                  name = "Steven Black's List";
                  id = 1759564899;
                }
                {
                  enabled = true;
                  url = "https://adguardteam.github.io/HostlistsRegistry/assets/filter_40.txt";
                  name = "TUR: Turkish Ad Hosts";
                  id = 1759564900;
                }
                {
                  enabled = true;
                  url = "https://adguardteam.github.io/HostlistsRegistry/assets/filter_41.txt";
                  name = "POL: CERT Polska List of malicious domains";
                  id = 1759564901;
                }
                {
                  enabled = true;
                  url = "https://adguardteam.github.io/HostlistsRegistry/assets/filter_26.txt";
                  name = "TUR: turk-adlist";
                  id = 1759564902;
                }
                {
                  enabled = true;
                  url = "https://adguardteam.github.io/HostlistsRegistry/assets/filter_55.txt";
                  name = "HaGeZi's Badware Hoster Blocklist";
                  id = 1759564903;
                }
              ];

              whitelist_filters = [
                {
                  id = 1001;
                  enabled = true;
                  name = "HaGeZi's Allowlist Referral";
                  url = "https://raw.githubusercontent.com/hagezi/dns-blocklists/main/adblock/whitelist-referral.txt";
                }
              ];
              user_rules = [
                "@@||sentry.io"
                "@@||analytex-us.userpilot.io"
                "@@||rules.aatkit.com"
              ];

              dhcp = {
                enabled = false;
                interface_name = "";
                local_domain_name = "lan";
                dhcpv4 = {
                  gateway_ip = "";
                  subnet_mask = "";
                  range_start = "";
                  range_end = "";
                  lease_duration = 86400;
                  icmp_timeout_msec = 1000;
                  options = [ ];
                };
                dhcpv6 = {
                  range_start = "";
                  lease_duration = 86400;
                  ra_slaac_only = false;
                  ra_allow_slaac = false;
                };
              };

              filtering = {
                blocking_ipv4 = "";
                blocking_ipv6 = "";
                blocked_services = {
                  schedule = {
                    time_zone = "Local";
                  };
                  ids = [ ];
                };
                protection_disabled_until = null;
                safe_search = {
                  enabled = false;
                  bing = true;
                  duckduckgo = true;
                  ecosia = true;
                  google = true;
                  pixabay = true;
                  yandex = true;
                  youtube = true;
                };
                blocking_mode = "null_ip";
                parental_block_host = "family-block.dns.adguard.com";
                safebrowsing_block_host = "standard-block.dns.adguard.com";
                rewrites = [
                  {
                    domain = "fritz.box";
                    answer = "192.168.178.1";
                  }
                ];
                safe_fs_patterns = [ "/var/lib/private/AdGuardHome/userfilters/*" ];
                safebrowsing_cache_size = 10485760;
                safesearch_cache_size = 10485760;
                parental_cache_size = 10485760;
                cache_time = 30;
                filters_update_interval = 24;
                blocked_response_ttl = 300;
                filtering_enabled = true;
                parental_enabled = false;
                safebrowsing_enabled = false;
                protection_enabled = true;
              };

              clients = {
                runtime_sources = {
                  whois = true;
                  arp = true;
                  rdns = true;
                  dhcp = true;
                  hosts = true;
                };
                persistent = [ ];
              };

              log = {
                enabled = true;
                file = "";
                max_backups = 0;
                max_size = 100;
                max_age = 3;
                compress = false;
                local_time = false;
                verbose = false;
              };

              os = {
                group = "";
                user = "";
                rlimit_nofile = 0;
              };

              schema_version = 29;
            };
          };
        };
        system.stateVersion = stateVersion;
      };
  };
}
