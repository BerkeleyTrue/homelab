{inputs, ...}: {
  nixos-parts = {
    enable = true;

    defaults = {
      hostPlatform = "x86_64-linux";
      stateVersion = "23.05";
    };

    shared = {
    };

    hosts = {
      homelab = {
        username = "bt";
        installer = inputs.nixpkgs + "/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix";
      };
    };
  };
}
