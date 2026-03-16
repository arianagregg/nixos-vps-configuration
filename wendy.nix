{ config, lib, pkgs, ... }:

{
  # Enable the web server
  services.nginx.enable = true;
}
