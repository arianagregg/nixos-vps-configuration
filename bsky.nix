{ config, lib, pkgs, ... }:

{
  services.bluesky-pds = {
    enable = true;
    pdsadmin.enable = true;
    environmentFiles = [
      ./bsky-secrets/config.env
    ];
    settings = {
      PDS_HOSTNAME = "bsky.telempiel.gay";
    };
  };
  networking.firewall.allowedTCPPorts = [ 3000 ];
}
