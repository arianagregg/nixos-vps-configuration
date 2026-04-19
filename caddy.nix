{ config, lib, pkgs, ... }:

{
  services.caddy = {
    globalConfig = ''
      on_demand_tls {
        ask http://127.0.0.1:3000
      }
      auto_https disable_redirects
    '';
    email = "webadmin@lovetocode999.xyz";
    virtualHosts = {
      "lovetocode999.xyz" = {
        serverAliases = [ "http://lovetocode999.xyz" ];
        extraConfig = ''
          root * /var/www/lovetocode999
          file_server
          php_fastcgi unix/${config.services.phpfpm.pools.mypool.socket}
        '';
      };
      "pds.telempiel.gay" = {
        serverAliases = [ "*.bsky.telempiel.gay" "bsky.telempiel.gay" "*.pds.telempiel.gay" ];
        extraConfig = ''
          reverse_proxy http://127.0.0.1:3000
          tls {
            on_demand
          }
        '';
      };
	  "matrix.telempiel.gay" = {
        extraConfig = ''
		  handle /_matrix/* {
		    reverse_proxy http://127.0.0.1:6167
		  }
		  handle {
            root * ${pkgs.cinny-unwrapped}
		    file_server
		    try_files {path} / index.html
		  }
		'';
	  };
      "matrix.telempiel.gay:443" = {
        extraConfig = ''
          handle /_matrix/* {
            reverse_proxy http://127.0.0.1:6167
          }
        '';
      };
      "matrix.telempiel.gay:8448" = {
        extraConfig = ''
          handle /_matrix/* {
            reverse_proxy http://127.0.0.1:6167
          }
        '';
      };
    };
  };
  #services.nginx = {
  #  virtualHosts = {
  #    localhost = {
  #      locations."/" = {
  #        return = "200 '<html><body>Impermanent server? I hardly know er!</body></html>'";
  #        extraConfig = ''
  #          default_type text/html;
  #        '';
  #      };
  #    };
  #    "lovetocode999.xyz" = {
  #      addSSL = true;
  #      enableACME = true;
  #      root = "/var/www/lovetocode999";
  #      locations."/" = {
  #        index = "index.php index.html";
  #      };
  #      locations."/robots.txt" = {
  #        extraConfig = ''
  #          rewrite ^/(.*)  $1;
  #          return 200 "User-agent: *\nDisallow: /";
  #        '';
  #      };
  #      locations."~ \\.php$".extraConfig = ''
  #        fastcgi_pass  unix:${config.services.phpfpm.pools.mypool.socket};
  #        fastcgi_index index.php;
  #      '';
  #    };
  #    "pds.telempiel.gay" = {
  #      forceSSL = true;
  #      enableACME = true;
  #      locations."/" = {
  #        proxyPass = "http://pds.telempiel.gay:3000/";
  #      };
  #    };
  #  };
  #};
  networking.firewall.allowedTCPPorts = [ 80 443 8448 6167 ];
  #security.acme = {
  #  acceptTerms = true;
  #  defaults.email = "webadmin@lovetocode999.xyz";
  #};
  services.phpfpm.pools.mypool = {
    user = "nobody";
    settings = {
      "pm" = "dynamic";
      "listen.owner" = config.services.caddy.user;
      "pm.max_children" = 5;
      "pm.start_servers" = 2;
      "pm.min_spare_servers" = 1;
      "pm.max_spare_servers" = 3;
      "pm.max_requests" = 500;
    };
  };
}
