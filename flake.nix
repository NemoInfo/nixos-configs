{
  description = "Dotfiles flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprland.url = "github:hyprwm/Hyprland";
    hyprland-plugins = {
      url = "github:hyprwm/hyprland-plugins";
      inputs.nixpkgs.follows = "hyprland";
    };
    more-waita = {
      url = "github:somepaulo/MoreWaita";
      flake = false;
    };

    ags.url = "github:Aylur/ags";
  };

  outputs = { nixpkgs, home-manager, ... }@inputs:
    let
      username = "aaron";
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
    in {
      nixosConfigurations."nixos" = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs username system; };
        modules = [ ./system/configuration.nix ];
      };
      homeConfigurations."aaron" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        extraspecialArgs = { inherit inputs username; };
        modules = [ ./user/home.nix ];
      };
    };
}
