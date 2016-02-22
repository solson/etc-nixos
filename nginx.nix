{
  networking.firewall.allowedTCPPorts = [ 80 ];

  services.nginx = {
    enable = true;
    httpConfig = ''
      server {
        server_name vps.solson.me;
        listen 80;
        listen [::]:80;

        location / {
          root /data/www;
        }
      }
    '';
  };
}
