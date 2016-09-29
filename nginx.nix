{ config, pkgs, ... }:

let
  dhParams = pkgs.runCommand "dh-params.pem"
    {
      buildInputs = [ pkgs.openssl ];
      preferLocalBuild = true;
    }
    "openssl dhparam -out $out 2048";

  sslConfig = ''
    ssl_certificate /etc/nginx/solson.me.crt;
    ssl_certificate_key /etc/nginx/solson.me.key;

    # Recommended security settings from https://wiki.mozilla.org/Security/Server_Side_TLS
    ssl_protocols TLSv1 TLSv1.1 TLSv1.2;
    ssl_ciphers 'ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-AES256-GCM-SHA384:DHE-RSA-AES128-GCM-SHA256:DHE-DSS-AES128-GCM-SHA256:kEDH+AESGCM:ECDHE-RSA-AES128-SHA256:ECDHE-ECDSA-AES128-SHA256:ECDHE-RSA-AES128-SHA:ECDHE-ECDSA-AES128-SHA:ECDHE-RSA-AES256-SHA384:ECDHE-ECDSA-AES256-SHA384:ECDHE-RSA-AES256-SHA:ECDHE-ECDSA-AES256-SHA:DHE-RSA-AES128-SHA256:DHE-RSA-AES128-SHA:DHE-DSS-AES128-SHA256:DHE-RSA-AES256-SHA256:DHE-DSS-AES256-SHA:DHE-RSA-AES256-SHA:AES128-GCM-SHA256:AES256-GCM-SHA384:AES128-SHA256:AES256-SHA256:AES128-SHA:AES256-SHA:AES:CAMELLIA:DES-CBC3-SHA:!aNULL:!eNULL:!EXPORT:!DES:!RC4:!MD5:!PSK:!aECDH:!EDH-DSS-DES-CBC3-SHA:!EDH-RSA-DES-CBC3-SHA:!KRB5-DES-CBC3-SHA';
    ssl_prefer_server_ciphers on;
    ssl_dhparam ${dhParams};

    ssl_session_timeout 5m;
    ssl_session_cache shared:SSL:5m;
  '';
in

{
  networking.firewall.allowedTCPPorts = [ 443 ];

  services.nginx = {
    enable = true;
    httpConfig = ''
      server {
        server_name solson.me;
        listen 443 ssl default_server;
        listen [::]:443 ssl default_server;

        location / {
          root /data/www/solson.me/root;
        }

        location /chat {
          root /data/www/solson.me; # /chat will be appended by nginx
        }

        ${sslConfig}
      }

      # Map subdomains to appropriate filesystem directories.
      server {
        server_name *.solson.me;
        listen 443;
        listen [::]:443;

        location / {
          root /data/www/$host;
        }

        ${sslConfig}
      }
    '';
  };
}
