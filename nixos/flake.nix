{
  description = "rewot-smibhuhb-config";

  # all dependencies of the flake that will be passed in as inputs
  inputs = {
    # NixOS official package source
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      # The `follows` keyword in inputs is used for inheritance.
      # Here, `inputs.nixpkgs` of home-manager is kept consistent with
      # the `inputs.nixpkgs` of the current flake,
      # to avoid problems caused by different versions of nixpkgs.
      inputs.nixpkgs.follows = "nixpkgs";
    };
    helix = {
      url = "github:helix-editor/helix/25.01.1";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, helix, ...}@inputs: {
    nixosConfigurations.rewot-smibmuhb = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        # Import previous configuration.nix file
        ./configuration.nix

        # Overlay
        {
          nixpkgs.overlays = [ helix.overlays.default ];
        }

        # make home-manager as a module of nixos
        # so home-manager config will be deployed automatically
        # when we do `nixos-rebuild switch`
        home-manager.nixosModules.home-manager {
          # ??
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;

          home-manager.users.matei = import ./home.nix;

          # We can use home-manager.extraSpecialArgs to pass in specialArgs
          # to module
        }
      ];
    };
  };
}
