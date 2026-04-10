{ config, lib, pkgs, ... }:
{
  services.matrix-continuwuity = {
    enable = true;
    admin.enable = true;
    settings = {
      global = {
        server_name = "matrix.telempiel.gay";
        allow_registration = true;
        allow_encryption = true;
        allow_federation = true;
	    };
    };
  };
}
