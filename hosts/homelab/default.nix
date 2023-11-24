{pkgs, ...}: {
  boot = {
    loader = {
      systemd-boot = {
        enable = true;
        timeout = 3;
        configurationLimit = 10;
      };
    };
    kernelParams = [
      "boot.shell_on_fail"
      "loglevel=3"
      "rd.systemd.show_status=auto"
      "rd.udev.log_level=3"
      "quiet"
    ];
  };

  console = {
    font = "${pkgs.tamzen}/share/consolefonts/TamzenForPowerline10x20.psf";
    keyMap = "uk";
    packages = with pkgs; [tamzen];
  };
}
