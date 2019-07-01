{ config, pkgs, ... }:

{
  networking.firewall.allowedTCPPorts = [ 80 443 ];

  security.acme.certs = {
    "solson.me" = {
      email = "scott@solson.me";
      extraDomains = {
        "dev.solson.me" = null;
      };
    };
  };

  services.nginx = {
    enable = true;

    recommendedGzipSettings = true;
    recommendedOptimisation = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;

    virtualHosts = {
      "solson.me" = {
        default = true;
        enableACME = true;
        forceSSL = true;
        locations."/".root = "/srv/www/solson.me";
      };

      "dev.solson.me" = {
        useACMEHost = "solson.me";
        forceSSL = true;
        locations."/".root = "/srv/www/dev.solson.me";
      };
    };
  };
}
