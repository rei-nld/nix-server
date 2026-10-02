{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };    # proxmox-nixos.url = "github:SaumonNet/proxmox-nixos";
  };
  outputs = { self, nixpkgs, home-manager, ... }: {
    nixosConfigurations = {
      nixos = nixpkgs.lib.nixosSystem rec {
        system = "x86_64-linux";
        modules = [ 
          ./configuration.nix
          home-manager.nixosModules.home-manager
          
          ({ pkgs, lib, ... }: {

            nixpkgs.overlays = [

            ];
          })
        ];
      };
    };
  };
}
