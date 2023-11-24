{
  inputs,
  modulesPath,
  ...
}: {
  nixos-parts = {
    enable = true;

    defaults = {
      hostPlatform = "x86_64-linux";
      stateVersion = "23.05";
    };

    shared = {
      modules = [
        (modulesPath + "/installer/scan/not-detected.nix") # not sure what this is for but it's in the example
        ./shared/nix-settings.nix
        ./shared/firewall.nix
        ./shared/misc.nix
      ];
    };

    hosts = {
      homelab = {
        username = "bt";
        installer = inputs.nixpkgs + "/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix";
      };
    };
  };
}
