{ ... }:

{
  imports = [ ./settings.nix ];

  containers.adguard = {
    autoStart = true;

    config =
      { lib, ... }:
      {
        services.adguardhome = {
          enable = true;
          port = 3000;
          settings = {
            upstream_dns = [
              # Unbound container
              "127.0.0.1:5353"
            ];
            user_rules = [
              "@@||nixos.wiki^$important"
              ""
            ];
            filters = [
              {
                enabled = true;
                url = "https://raw.githubusercontent.com/hagezi/dns-blocklists/main/adblock/pro.txt";
                name = "Hagezi Multi PRO - Extended protection";
              }
              {
                enabled = false;
                url = "https://adguardteam.github.io/HostlistsRegistry/assets/filter_1.txt";
                name = "AdGuard DNS filter";
              }
              {
                enabled = false;
                url = "https://adguardteam.github.io/HostlistsRegistry/assets/filter_51.txt";
                name = "HaGeZi's Pro++ Blocklist";
              }
              {
                enabled = false;
                url = "https://adguardteam.github.io/HostlistsRegistry/assets/filter_59.txt";
                name = "AdGuard DNS Popup Hosts filter";
              }
              {
                enabled = false;
                url = "https://adguardteam.github.io/HostlistsRegistry/assets/filter_33.txt";
                name = "Steven Black's List";
              }
              {
                enabled = false;
                url = "https://adguardteam.github.io/HostlistsRegistry/assets/filter_46.txt";
                name = "HaGeZi's Anti-Piracy Blocklist";
              }
              {
                enabled = false;
                url = "https://adguardteam.github.io/HostlistsRegistry/assets/filter_47.txt";
                name = "HaGeZi's Gambling Blocklist";
              }
              {
                enabled = false;
                url = "https://adguardteam.github.io/HostlistsRegistry/assets/filter_44.txt";
                name = "HaGeZi's Threat Intelligence Feeds";
              }
              {
                enabled = false;
                url = "https://adguardteam.github.io/HostlistsRegistry/assets/filter_50.txt";
                name = "uBlock₀ filters – Badware risks";
              }
              {
                enabled = false;
                url = "https://adguardteam.github.io/HostlistsRegistry/assets/filter_54.txt";
                name = "HaGeZi's DynDNS Blocklist";
              }
              {
                enabled = false;
                url = "https://adguardteam.github.io/HostlistsRegistry/assets/filter_55.txt";
                name = "HaGeZi's Badware Hoster Blocklist";
              }
            ];
          };
        };
        networking = {
          firewall = {
            enable = true;
            allowedTCPPorts = [ 3000 ];
          };
          # Use systemd-resolved inside the container
          # Workaround for bug https://github.com/NixOS/nixpkgs/issues/162686
          useHostResolvConf = lib.mkForce false;
        };

        system.stateVersion = "24.11";
      };
  };
}
