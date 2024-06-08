{ ... }:

{
  services.tailscale = {
    enable = true;
    useRoutingFeatures = "both";
    permitCertUid = "caddy";
  };
}
