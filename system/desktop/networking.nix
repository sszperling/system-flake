{ hostname, ... }:

{
  services.tailscale = {
    useRoutingFeatures = "client";
  };
}