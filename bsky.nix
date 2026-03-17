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
}
