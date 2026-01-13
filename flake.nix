{
  description = "rewot-smibhuhb-config";

  # all dependencies of the flake that will be passed in as inputs
  inputs = {
    # NixOS official package source
    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      # The `follows` keyword in inputs is used for inheritance.
      # Here, `inputs.nixpkgs` of home-manager is kept consistent with
      # the `inputs.nixpkgs` of the current flake,
      # to avoid problems caused by different versions of nixpkgs.
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";

    # overlays
    helix = {
      url = "github:helix-editor/helix/25.01.1";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    neovim-nightly = {
      url = "github:nix-community/neovim-nightly-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # TODO: my own overlay
    niri.url = "github:sodiboo/niri-flake";
    # homebrewed
    baan.url = "github:mateiidavid/baan";
  };

  outputs = {
    baan,
    helix,
    home-manager,
    neovim-nightly,
    niri,
    nixpkgs,
    ...
  }: let
    nixosConfigurations = {
      rewot-smibmuhb = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        # Another way to import helix
        # specialArgs = [ inputs ];
        # and then in home-manager we can consume it with inputs.helix.packages.${pkgs.system}.helix

        modules = [
          # Import previous configuration.nix file
          ./system
          (import ./pkgs/firefox.nix {user = "matei";})

          # Overlay
          {
            nixpkgs.overlays = [
              baan.overlays.default
              helix.overlays.default
              neovim-nightly.overlays.default
              niri.overlays.niri
              (import ./pkgs/claude-code.nix {})
            ];
          }

          # make home-manager as a module of nixos
          # so home-manager config will be deployed automatically
          # when we do `nixos-rebuild switch`
          home-manager.nixosModules.home-manager
          {
            # ??
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;

            home-manager.users.matei = import ./home.nix;

            # We can use home-manager.extraSpecialArgs to pass in specialArgs
            # to module
            # home-manager.extraSpecialArgs = { inherit baan; };
          }
        ];
      };
    };
    devShells = let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      devShells.${system}.default = import ./shell.nix {inherit pkgs;};
    };
  in
    {
      inherit nixosConfigurations;
      homeManagerModules.nvim = import ./pkgs/nvim.nix;
    } // devShells;
}
# when to use overlays vs override vs different inputs (specialArgs)
# apparently:
#     overlays are good when we need to replace the actual libraries (although great for pkgs too)
#     specialArgs, e.g. multiple flake imports pinned to diff version and passed through as specialArgs
#                 to other modules
#
# NOTE: for an overlay, Nix will recompile all installed packages that depend on _it_. sounds like this
# is for a library.
#
#
# callPackage, `overlays` and `overrides` are useful for _BUILDING_ a package
# Overlays just modify the package globally so you don't modify it just at the callsite. esp. if it's a package
# other packages rely on

