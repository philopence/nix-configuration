{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.features.rofi;
in {
  options.features.rofi = {
    enable = mkEnableOption "";
  };

  config = mkIf cfg.enable {
    programs.rofi = {
      enable = true;
      extraConfig = {
        modi = "drun,window";
        show-icons = false;
        drun-display-format = "{name}";
        drun-match-fields = "name";
      };

      theme = let
        inherit (config.lib.formats.rasi) mkLiteral;
      in {
        "*" = {
          font = "Sans 12";
          bg = mkLiteral "#1a1b26";
          fg = mkLiteral "#c0caf5";
          normal = mkLiteral "#565f89";
          active = mkLiteral "#ff9e64";
        };

        "window" = {
          width = mkLiteral "30%";
        };

        "mainbox" = {
          padding = mkLiteral "10";
          background-color = mkLiteral "@bg";
          children = map mkLiteral ["inputbar" "line" "listview"];
        };

        "inputbar" = {
          children = map mkLiteral ["entry"];
          # padding = mkLiteral "20";
          # background-image = mkLiteral "url(\"~/Pictures/bg.jpg\", width)";
        };

        "entry" = {
          horizontal-align = mkLiteral "0.5";
          text-color = mkLiteral "@fg";
          background-color = mkLiteral "@bg";
          # background-color = mkLiteral "transparent";
          padding = mkLiteral "10";
        };

        "line" = {
          expand = mkLiteral "false";
          padding = mkLiteral "1px";
          background-image = mkLiteral "linear-gradient(to right, #c0caf5, #1a1b26)";
        };

        "listview" = {
          padding = mkLiteral "10 0";
          spacing = mkLiteral "5";
          background-color = mkLiteral "@bg";
        };

        "element-text" = {
          text-color = mkLiteral "inherit";
          background-color = mkLiteral "inherit";
          vertical-align = mkLiteral "0.5";
          horizontal-align = mkLiteral "0.5";
        };

        "element normal" = {
          text-color = mkLiteral "@normal";
          background-color = mkLiteral "@bg";
        };

        "element alternate" = {
          text-color = mkLiteral "@normal";
          background-color = mkLiteral "@bg";
        };

        "element selected" = {
          text-color = mkLiteral "@active";
          background-color = mkLiteral "@bg";
        };
      };
    };
  };
}
