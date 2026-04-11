{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    # proxmox-nixos.url = "github:SaumonNet/proxmox-nixos";
  };
  outputs = { self, nixpkgs, ... }: {
    nixosConfigurations = {
      nixos = nixpkgs.lib.nixosSystem rec {
        system = "x86_64-linux";
        modules = [ 
          ./configuration.nix
          # proxmox-nixos.nixosModules.proxmox-ve
          
          ({ pkgs, lib, ... }: {
            # services.proxmox-ve = {
              # enable = true;
              # ipAddress = "192.168.0.250";
            # };
            nixpkgs.overlays = [
              # proxmox-nixos.overlays.${system}
            ];
          })
        ];
      };
    };
  };
}
