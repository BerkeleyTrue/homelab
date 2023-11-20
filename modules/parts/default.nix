{inputs, ...}: {
  imports = [
    ./nixos-parts.nix
  ];

  perSystem = {
    lib,
    system,
    inputs',
    ...
  }: {
    _module.args = rec {
      nixpkgs = {
        config = lib.mkForce {
          allowUnfree = true;
        };

        hostPlatform = system;
      };

      extraModuleArgs = {
        inherit inputs' system;
        inputs = lib.mkForce inputs;

        repos = let
          pkgsFrom = branch: system:
            import branch {
              inherit system;
              inherit (nixpkgs) config overlays;
            };
        in {
          stable = pkgsFrom inputs.stable system;
          unstable = pkgsFrom inputs.unstable system;
        };
      };

      pkgs = extraModuleArgs.repos.stable;
    };
  };
}
