{ config, lib, pkgs, ... }:

{
  services.bluesky-pds = {
    enable = true;
    environmentFiles = [
      ./bsky-secrets/config.env
    ];
    settings = {
      PDS_HOSTNAME = "pds.telempiel.gay";
    };
  };
  networking.firewall.allowedTCPPorts = [ 3000 ];
  security.acme.certs."telempiel.gay" = {webroot = "/var/www/telempiel/acme/acme-challenge";};
}
