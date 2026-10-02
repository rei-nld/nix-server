# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:
{
  imports =
    [
      ./hardware-configuration.nix
      ./modules
    ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos"; # Define your hostname.
  networking.networkmanager.enable = true;
  networking.enableIPv6 = false;

  time.timeZone = "Europe/Paris";

  i18n.defaultLocale = "en_US.UTF-8";
  console.keyMap = "fr";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "fr_FR.UTF-8";
    LC_IDENTIFICATION = "fr_FR.UTF-8";
    LC_MEASUREMENT = "fr_FR.UTF-8";
    LC_MONETARY = "fr_FR.UTF-8";
    LC_NAME = "fr_FR.UTF-8";
    LC_NUMERIC = "fr_FR.UTF-8";
    LC_PAPER = "fr_FR.UTF-8";
    LC_TELEPHONE = "fr_FR.UTF-8";
    LC_TIME = "fr_FR.UTF-8";
  };

  users.users.nixos = {
    isNormalUser = true;
    extraGroups = [ "wheel" "docker" "video" "render" ];
  };
  
  home-manager.users.nixos = { pkgs, ... }: {
    services.ssh-agent.enable = true;
    programs.bash = {
      enable = true;
      bashrcExtra = ''
        ssh-add -l > /dev/null 2>&1 || ssh-add ~/.ssh/id_github
      '';
    };
    programs.git.enable = true;
    home.stateVersion = "26.05";
  };

  security.sudo = {
    extraRules = [{
        users = ["nixos"];
        host = "ALL";
        runAs = "ALL:ALL";
        commands = [{
            command = "ALL";
            options = ["NOPASSWD"];
        }];
    }];
  };

  environment.systemPackages = with pkgs; [
    nvtopPackages.nvidia
  ];

  services.openssh.enable = true;

  virtualisation.docker = {
    enable = true;
    package = pkgs.docker_29;
  };

  nixpkgs.config.allowUnfree = true;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  system.stateVersion = "25.11"; # Watch out!
}
