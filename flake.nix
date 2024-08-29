{
  description = "Home Manager configuration of nick";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";
    unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "unstable";
    };

    catppuccin.url = "github:catppuccin/nix";
  };

  outputs = { self, nixpkgs, unstable, home-manager, ... }@inputs:
    let
      inherit (self) outputs;
      # Determines compatible Home Manager release. Check Home Manager release
      # notes before updating.
      stateVersion = "24.05";
      username = "nick";

      libx = import ./lib {
        inherit
          self
          inputs
          outputs
          stateVersion
          username
          ;
      };
    in {
      homeConfigurations = {
        "nick" = libx.mkHome { };
      };

      lib = {
        inherit (libx) mkHome forAllSystems;
      };

      # Devshell for bootstrapping
      # Accessible via 'nix develop' or 'nix-shell' (legacy)
      devShells = libx.forAllSystems (
        system:
        let
          pkgs = unstable.legacyPackages.${system};
        in
        import ./shell.nix { inherit pkgs; }
      );
    };
}
