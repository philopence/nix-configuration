{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.features.picom;
in {
  options.features.picom = {
    enable = mkEnableOption "";
  };

  config = mkIf cfg.enable {
    services.picom = {
      enable = true;
      backend = "glx";
      activeOpacity = 1.0;
      fade = true;
      shadow = true;
      settings = {
        frame-opacity = 1.0;
        blur = {
          method = "dual_kawase";
          strength = 5;
        };
        wintypes = {
          menu = {
            blur-background = false;
            shadow = false;
          };
        };
      };
    };
  };
}
