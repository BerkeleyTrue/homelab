{
  config,
  lib,
  inputs,
  withSystem,
  ...
}: let
  inherit (lib) mkOption mkEnableOption types optionals;
  cfg = config.nixos-parts;
  shared = cfg.shared;
  hosts = cfg.hosts;
in {
  options.nixos-parts = {
    shared = {
      modules = mkOption {
        type = types.listOf types.unspecified;
        description = "Shared modules for all hosts";
        default = [];
      };

      extraSpecialArgs = mkOption {
        type = types.attrs;
        default = {};
        description = ''
          option can be used to pass additional arguments to all modules on all hosts.
        '';
      };
    };

    hosts = mkOption {
      type = types.attrsOf (types.submodule ({
        name, # key of attr
        config,
        lib,
        ...
      }: {
        options = {
          enable = mkEnableOption {
            default = false;
            description = "Enable hosts ${name}'s flake";
          };

          username = mkOption {
            type = types.str;
            description = "Username for hosts ${name}, defaults to config key";
            default = name;
          };

          hostname = mkOption {
            type = types.str;
            description = "Hostname for ${name}";
            required = true;
          };

          installer = mkOption {
            type = types.unspecified;
            description = "Installer for hosts ${name}";
          };

          modules = mkOption {
            type = types.listOf types.unspecified;
            default = [];
            description = "Modules for hosts ${name} (in addition to the default modules and installer)";
          };

          specialArgs = mkOption {
            type = types.attrs;
            default = {};
            description = ''
              option can be used to pass additional arguments to all modules on this host.
            '';
          };

          system = mkOption {
            type = types.enum ["aarch64-linux" "x86_64-linux"];
            description = "System configuration for hosts ${name}";
            default = "x86_64-linux";
          };

          stateVersion = mkOption {
            type = types.str;
            description = "State version for hosts ${name}";
          };

          nixos = mkOption {
            type = types.unspecified;
            readOnly = true;
            description = "The derived NixOS configuration for hosts ${name}";
          };
        };

        config.nixos = withSystem config.system (ctx:
          inputs.nixpkgs.lib.nixosSystem {
            specialArgs = {
              inherit (shared) extraSpecialArgs;
              inherit (config) specialArgs system stateVersion username hostname;
            };

            modules =
              [shared.modules]
              ++ (optionals (config.installer != null) [config.installer])
              # additional modules
              ++ config.modules;
          });
      }));
    };
  };

  config.flake.nixosConfigurations = builtins.mapAttrs (_: value: value.nixos) hosts;
}
