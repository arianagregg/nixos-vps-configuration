{ config, lib, pkgs, inputs, ... }:

{
  services.tranquil-pds = {
    enable = true;
    database.createLocally = true;
    environmentFiles = [
      ./tranquil/config.env
      ./tranquil/secrets/config.env
    ];
    settings = {
      server = {
        hostname = "pds.telempiel.gay";
      };
    };
  };
  networking.firewall.allowedTCPPorts = [ 3000 ];
  security.acme.certs."telempiel.gay-pds" = {
    webroot = "/var/www/telempiel/acme/acme-challenge/";
    domain = "telempiel.gay";
    #user = config.services.tranquil-pds.user;
    group = "nginx";
    extraDomainNames = [
      "pds.telempiel.gay"
    ];
  };
}
