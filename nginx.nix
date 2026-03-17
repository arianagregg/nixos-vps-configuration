{ config, lib, pkgs, ... }:

{
  services.nginx = {
    virtualHosts = {
      localhost = {
        locations."/" = {
	  return = "200 '<html><body>Impermanent server? I hardly know er!</body></html>'";
          extraConfig = ''
            default_type text/html;
          '';
	};
      };
      "lovetocode999.xyz" = {
        addSSL = true;
	enableACME = true;
	root = "/var/www/lovetocode999";
	locations."/" = {
	  index = "index.php index.html";
	};
	locations."/robots.txt" = {
          extraConfig = ''
            rewrite ^/(.*)  $1;
            return 200 "User-agent: *\nDisallow: /";
          '';
        };
	locations."~ \\.php$".extraConfig = ''
          fastcgi_pass  unix:${config.services.phpfpm.pools.mypool.socket};
          fastcgi_index index.php;
        '';
      };
    };
  };
  networking.firewall.allowedTCPPorts = [ 80 443 ];
  security.acme = {
    acceptTerms = true;
    defaults.email = "webadmin@lovetocode999.xyz";
  };
  services.phpfpm.pools.mypool = {
    user = "nobody";
    settings = {
      "pm" = "dynamic";
      "listen.owner" = config.services.nginx.user;
      "pm.max_children" = 5;
      "pm.start_servers" = 2;
      "pm.min_spare_servers" = 1;
      "pm.max_spare_servers" = 3;
      "pm.max_requests" = 500;
    };
  };
}
