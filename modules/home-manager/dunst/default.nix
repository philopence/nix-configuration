{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.features.dunst;

  foreground = "#c0caf5";
  background = "#1a1b26";
  frame_color = "#c0caf5";
in {
  options.features.dunst = {
    enable = mkEnableOption "";
  };

  config = mkIf cfg.enable {
    services.dunst = {
      enable = true;
      settings = {
        global = {
          offset = "15x15";
          frame_width = 2;
          font = "Monospace 10";
          inherit frame_color;
        };
        urgency_low = {
          timeout = 3;
          inherit foreground background;
        };
        urgency_normal = {
          timeout = 5;
          inherit foreground background;
        };
        urgency_critical = {
          timeout = 0;
          inherit foreground background;
        };
      };
    };
  };
}
