{
  description = "My homelab configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.05";

    flake-parts.url = "github:hercules-ci/flake-parts";

    ### -- package repos
    stable.url = "github:nixos/nixpkgs/release-23.05";
    unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nur.url = "github:nix-community/NUR";
    home-manager.url = "github:nix-community/home-manager";

    nixpkgs.follows = "stable";

    flake-parts.inputs.nixpkgs-lib.follows = "nixpkgs";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs @ {flake-parts, ...}:
    flake-parts.lib.mkFlake {inherit inputs;} {
      systems = ["x86_64-linux"];
      imports = [
        ./modules/parts
      ];

      perSystem = {pkgs, ...}: {
        formatter = pkgs.alejandra;
      };
    };
}
