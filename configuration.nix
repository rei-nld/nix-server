# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:
{
  imports =
    [
      ./hardware-configuration.nix
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
    extraGroups = [ "wheel" "docker" ];
    packages = with pkgs; [
      git
    ];
  };
  
  home-manager.users.nixos = { pkgs, ... }: {
    services.ssh-agent.enable = true;
    programs.bash = {
      enable = true;
      bashrcExtra = ''
        ssh-add -l > /dev/null 2&>1 || ssh-add ~/.ssh/id_github
        '';
    };
    home.stateVersion = "25.11";
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
    # foot
  ];

  services.openssh.enable = true;

  virtualisation.docker = {
    enable = true;
  };

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nixpkgs.config.allowUnfree = true;
  system.stateVersion = "25.11"; # Did you read the comment?

}

