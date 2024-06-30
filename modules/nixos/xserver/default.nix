{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.features.xserver;
in {
  options.features.xserver = {
    enable = mkEnableOption "";
  };

  config = mkIf cfg.enable {
    services.xserver = {
      enable = true;
      displayManager.lightdm.enable = true;
      # displayManager.lightdm.greeters.mini = {
      #   enable = true;
      #   user = "philopence";
      # };
      windowManager.dk.enable = true;
    };
    services.libinput.touchpad.naturalScrolling = true;
  };
}
