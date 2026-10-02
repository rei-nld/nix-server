{ config, lib, pkgs, nixpkgs-unstable, ... }:
let
  opencode-unstable = nixpkgs-unstable.legacyPackages.${pkgs.stdenv.hostPlatform.system}.opencode;
in
{
  users.users.nixos = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "docker"
    ];
  };
  
  home-manager.users.nixos = { pkgs, ... }: {
    programs.opencode = {
      enable = true;
      package = opencode-unstable;
    };
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
}
