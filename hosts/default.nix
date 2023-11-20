{extraModuleArgs, ...}: {
  nixos-parts.shared = {
    extraSpecialArgs = extraModuleArgs;
  };

  nixos-parts = {
    hl1 = {
      system = "x86_64-linux";
      stateVersion = "23.05";
    };
  };
}
