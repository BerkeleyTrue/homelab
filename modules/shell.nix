{...}: {
  perSystem = {
    config,
    lib,
    pkgs,
    ...
  }: let
    buildIsoImage = pkgs.writeShellScriptBin "build-iso-image" ''
      system=$1
      nix build .\#nixosConfigurations.$system.config.system.build.isoImage
    '';
  in {
    boulder.commands = [
      {
        exec = buildIsoImage;
        description = "Build ISO image";
      }
    ];

    devShells.default = pkgs.mkShell {
      name = "homelab";
      buildInputs = [buildIsoImage];
      inputsFrom = [config.boulder.devShell];
    };
  };
}
