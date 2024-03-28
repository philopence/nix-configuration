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
      fade = true;
      fadeSteps = [ 0.07 0.07 ];
      shadow = true;
      shadowExclude = [
        "window_type = 'menu'"
      ];
      settings = {
        # blur = {
        #   method = "dual_kawase";
        #   strength = "10";
        #   background-exclude = [
        #     "class_g = 'Chromium-browser'"
        #     "window_type = 'menu'"
        #     "window_type = 'dropdown_menu'"
        #     "window_type = 'popup_menu'"
        #     "window_type = 'tooltip'"
        #   ];
        # };
      };
    };
  };
}
