{ config, lib, pkgs, ... }:
{
  users.users.nixos = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "docker"
    ];
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
}
