{ config, lib, pkgs, modulesPath, hostname, ... }:

{
  imports = [
    (modulesPath + "/profiles/qemu-guest.nix")
    ./nginx.nix
  ];

  boot.initrd.availableKernelModules = [ "ahci" "xhci_pci" "virtio_pci" "virtio_scsi" "sd_mod" "sr_mod" ];

  networking.useDHCP = lib.mkDefault true;
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

  # Somehow prevents "mirroredBoots" error??? Idk man just leave it alone
  boot.loader.grub.device = lib.mkForce "/dev/sda";
  boot.loader.grub.devices = lib.mkForce [ "/dev/sda" ];

  environment.systemPackages = with pkgs; [
    cowsay
    fortune
    htop
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

  programs.zsh.enable = true;

  users.mutableUsers = false;
  users.users.cxefa = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBLFdD+qIFApRViRbqyWJTJads23WuGAwvxZPMDRnWKf telempiel"
    ];
    shell = pkgs.zsh;
  };

  # passwordless sudo
  security.sudo.wheelNeedsPassword = false;

  # security stuff
  services.fail2ban.enable = true;
  services.endlessh = {
    enable = true;
    port = 22;
    openFirewall = true;
  };

  # Enable qemu-guest-agent for management from the Hetzner console
  services.qemuGuest.enable = true;
  # Enable auto login for easier debugging from Hetzner
  services.getty.autologinUser = "cxefa";

  # Hostname
  networking.hostName = "${hostname}";

  services.cron = {
    enable = true;
    systemCronJobs = [
      # Reboot daily
      "0 0 * * * root reboot"
    ];
  };

  # Enable some experimental features
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  system.stateVersion = "25.11";
}
