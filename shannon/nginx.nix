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
      # A catchall vhost (with empty server name) in case this nginx server
      # gets visited directly by IP or through another subdomain that it
      # doesn't know about.
      "''" = {
        default = true;
        globalRedirect = "solson.me";
      };

      "solson.me" = {
        enableACME = true;
        forceSSL = true;
        extraConfig =
          "add_header Strict-Transport-Security 'max-age=31536000';";
        locations."/".root = "/srv/www/solson.me";
      };

      "dev.solson.me" = {
        useACMEHost = "solson.me";
        forceSSL = true;
        extraConfig =
          "add_header Strict-Transport-Security 'max-age=31536000';";
        locations."/".root = "/srv/www/dev.solson.me";
      };
    };
  };
}
