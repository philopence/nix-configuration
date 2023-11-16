{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.features.xserver;
in

{
  options.features.xserver = {
    enable = mkEnableOption "";
  };

  config = mkIf cfg.enable {
    services.xserver = {
      enable = true;
      displayManager.lightdm.enable = true;
      ## windowManager.bspwm.enable = true;
      windowManager.dk.enable = true;
      libinput.touchpad.naturalScrolling = true;
    };
  };
}
