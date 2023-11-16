{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.features.dunst;
in

{
  options.features.dunst = {
    enable = mkEnableOption "";
  };

  config = mkIf cfg.enable {
    services.dunst = {
      enable = true;
      settings =
        let
          common = {
            foreground = "#${config.colorScheme.colors.base06}";
            background = "#${config.colorScheme.colors.base00}";
          };
        in
        {
          global = {
            offset = "15x15";
            frame_width = 5;
            frame_color = "#${config.colorScheme.colors.base02}";
          };
          urgency_low = {
            timeout = 3;
          } // common;
          urgency_normal = {
            timeout = 5;
          } // common;
          urgency_critical = {
            timeout = 0;
          } // common;
        };
    };
  };
}
