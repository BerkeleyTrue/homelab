{
  pkgs,
  inputs',
  modulesPath,
  ...
}: {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix") # not sure what this is for but it's in the example
    ./nix-settings.nix
    ./firewall.nix
    ./misc.nix
  ];

  environment = {
    systemPackages = with pkgs; [
      gitMinimal
      home-manager
      neovim
      ripgrep
      rsync
      inputs'.fh.packages.default
    ];

    variables = rec {
      EDITOR = "nvim";
      SYSTEMD_EDITOR = EDITOR;
      VISUAL = EDITOR;
    };
  };
}
