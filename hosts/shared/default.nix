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
      bind # dns client
      cryptsetup
      curl # for downloading stuff
      dogdns # dns client
      du-dust # disk usage
      efibootmgr
      efivar
      eza # modern replacement of ls
      fd # modern replacement of find
      fuse
      fuse3
      fzf # fuzzy finder
      gitMinimal
      gptfdisk
      home-manager
      htop
      inputs'.fh.packages.default
      iputils # ping
      lsof
      neovim
      ngrok
      p7zip
      parted
      procs
      ripgrep
      rsync
      rustscan
      silver-searcher
      socat
      sshfs-fuse
      tmux
      traceroute
      udisks
      wget # for downloading stuff

      # for hardware
      sdparm
      hdparm
      smartmontools # for diagnosing hard disks
      pciutils
      usbutils
      nvme-cli
    ];

    variables = rec {
      EDITOR = "nvim";
      SYSTEMD_EDITOR = EDITOR;
      VISUAL = EDITOR;
    };
  };
}
