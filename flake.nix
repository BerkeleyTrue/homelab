{
  description = "My homelab configuration";

  inputs = {
    flake-parts.url = "github:hercules-ci/flake-parts";

    ### -- package repos
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.05";
    unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nur.url = "github:nix-community/NUR";
    home-manager.url = "github:nix-community/home-manager";

    flake-parts.inputs.nixpkgs-lib.follows = "nixpkgs";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs @ {flake-parts, ...}:
    flake-parts.lib.mkFlake {inherit inputs;} {
      systems = ["x86_64-linux"];
      imports = [
        ./modules/parts
        ./hosts
      ];

      perSystem = {
        lib,
        system,
        inputs',
        ...
      }: let
        pkgs = import inputs.nixpkgs {
          inherit system;
          hostPlatform = system;
          config = {
            allowUnfree = true;
          };
        };
        unstable = import inputs.unstable {
          inherit system;
          inherit (pkgs) config overlays;
        };
      in {
        formatter = pkgs.alejandra;

        _module.args = {
          inherit pkgs unstable;
        };
      };
    };
}
