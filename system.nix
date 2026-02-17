{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [
    (modulesPath + "/profiles/qemu-guest.nix")
  ];

  boot.initrd.availableKernelModules = [ "ahci" "xhci_pci" "virtio_pci" "virtio_scsi" "sd_mod" "sr_mod" ];

  networking.useDHCP = lib.mkDefault true;
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

  boot.loader.grub.device = "/dev/sda";

  environment.systemPackages = with pkgs; [
    neovim
    wget
    tree
  ];

  services.openssh = {
    enable = true;
    ports = [ 5432 ];
    settings = {
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
      PermitRootLogin = "no";
      AllowUsers = [ "cxefa" ];
    };
  };

  users.mutableUsers = false;
  users.users.cxefa = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBLFdD+qIFApRViRbqyWJTJads23WuGAwvxZPMDRnWKf telempiel"
    ];
    shell = pkgs.zsh;
  };

  # last resort in case of accidental deletion of /etc/nixos
  system.copySystemConfiguration = true;

  system.stateVersion = "25.05";
}
