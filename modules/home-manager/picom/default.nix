{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.features.picom;
in

{
  options.features.picom = {
    enable = mkEnableOption "";
  };

  config = mkIf cfg.enable {
    services.picom = {
      enable = true;
      backend = "glx";
      activeOpacity = 1;
      # opacityRules = [
      #   "100:window_type *= 'menu'"
      # ];
      fade = true;
      fadeSteps = [ 0.07 0.07 ];
      shadow = true;
      shadowExclude = [ ];
      # shadowOffsets = [ (-5) (-5) ];
      # shadowOpacity = 0.5;
      # wintypes = {
      #   popup_menu = { blur-background = false; shadow = false; };
      #   utility = { blur-background = false; shadow = false; };
      # };
      settings = {
        #shadow-radius = 15;
        blur = {
          ## method = "gaussian";
          ## size = 10;
          ## deviation = 5.0;
          method = "dual_kawase";
          strength = "10";
        };
      };
    };
  };
}
