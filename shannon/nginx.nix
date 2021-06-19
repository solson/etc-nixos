{ config, pkgs, ... }:

{
  networking.firewall.allowedTCPPorts = [ 80 443 ];

  security.acme = {
    acceptTerms = true;
    certs = {
      "solson.me" = {
        email = "scott@solson.me";
        extraDomainNames = [ "dev.solson.me" ];
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
        locations = {
          "/".root = "/srv/www/solson.me";
          "/files/".alias = "/srv/www/solson.me-files/";
          "/irc/".extraConfig = ''
            proxy_pass http://127.0.0.1:${toString config.services.thelounge.port}/;
            proxy_http_version 1.1;
            proxy_set_header Connection "upgrade";
            proxy_set_header Upgrade $http_upgrade;
            proxy_set_header X-Forwarded-For $remote_addr;
            proxy_set_header X-Forwarded-Proto $scheme;
            proxy_read_timeout 1d;
            client_max_body_size 0;
          '';
          "/irc/uploads/".extraConfig = ''
            proxy_pass http://127.0.0.1:${toString config.services.thelounge.port}/uploads/;
            proxy_http_version 1.1;
            proxy_set_header Connection "upgrade";
            proxy_set_header Upgrade $http_upgrade;
            proxy_set_header X-Forwarded-For $remote_addr;
            proxy_set_header X-Forwarded-Proto $scheme;
            proxy_read_timeout 1d;
            proxy_hide_header Content-Disposition;
            add_header Content-Disposition "inline";
            client_max_body_size 0;
          '';
        };
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
