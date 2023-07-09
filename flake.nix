{
  description = "My homelab configuration";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    flake-parts.url = "github:hercules-ci/flake-parts";
  };

  outputs = inputs@{ self, flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit self inputs; } {
      systems = [ "x86_64-linux" "x86_64-darwin" ];

      perSystem = { self', config, system, pkgs, lib, ... }:
      let
        run-containers = pkgs.writeShellScriptBin "run-containers" ''
          ansible-playbook container_playbook.yml --ask-become
        '';

        run-main = pkgs.writeShellScriptBin "run-main" ''
          ansible-playbook main_playbook.yml --ask-become
        '';

        run-harden = pkgs.writeShellScriptBin "run-harden" ''
          ansible-playbook harden_playbook.yml
        '';

        run-rasp-init = pkgs.writeShellScriptBin "run-rasp-init" ''
          ansible-playbook rasp_init_playbook.yml
        '';

      in
      {
        formatter = pkgs.nixpkgs-fmt;

        devShells.default = pkgs.mkShell {
          name = "homelab";

          packages = with pkgs; [
            ansible
            ansible-language-server
            ansible-later
            ansible-lint
            yamlfix
            nodePackages.yaml-language-server

            run-containers
            run-main
            run-harden
            run-rasp-init
          ];

          shellHook = ''
            export NIX_SHELL_NAME="homelab"
            zsh
            exit 0
          '';
        };
      };

  };
}
