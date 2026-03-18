{ config, lib, pkgs, ... }:

{
  # Enable the web server
  services.caddy.enable = true;
}
