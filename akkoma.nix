{ config, lib, pkgs, ... }:

{
  services.akkoma = {
    enable = true;
    config = {
      ":joken" = {
        ":default_signer" = {
          _secret = "/persist/secrets/akkoma/jwt-signer";
        };
      };
      ":pleroma" = {
        ":instance" = {
          name = "fedi.telempiel.gay";
          description = "telempiel's gay little corner of the fediverse";
          email = "admin@lovetocode999.xyz";
          registration_open = false;
        };
        "Pleroma.Web.Endpoint" = {
          secret_key_base = {
            _secret = "/persist/secrets/akkoma/key-base";
          };
          signing_salt = {
            _secret = "/persist/secrets/akkoma/signing-salt";
          };
          url.host = "fedi.telempiel.gay";
        };
        "Pleroma.Upload" = {
          base_url = "https://media.telempiel.gay/akkoma/";
        };
      };
    };
  };
  environment.persistence."/persist".directories = [
    {
      directory = "${config.services.akkoma.config.":pleroma".":instance".upload_dir}";
      user = config.services.akkoma.user;
      group = config.services.akkoma.group;
      mode = "755";
    }
  ];
  services.caddy.virtualHosts."fedi.telempiel.gay" = {
    extraConfig = ''
      reverse_proxy unix//${config.services.akkoma.config.":pleroma"."Pleroma.Web.Endpoint".http.ip}
    '';
  };
}
