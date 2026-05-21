{ config, lib, pkgs, ... }:

{
  services.postgresql = {
    enable = true;
    package = pkgs.postgresql_18;
  };
  environment.persistence."/persist".directories = [
    {
      directory = "${config.services.postgresql.dataDir}";
      user = "postgres";
      group = "postgres";
      mode = "700";
    }
  ];
}
