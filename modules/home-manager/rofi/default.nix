{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.features.rofi;
in

{
  options.features.rofi = {
    enable = mkEnableOption "";
  };

  config = mkIf cfg.enable {
    programs.rofi = {
      enable = true;
      extraConfig = {
        display-drun = "";
        drun-display-format = "{name}";
        drun-match-fields = "name";
      };
      theme =
        let
          inherit (config.lib.formats.rasi) mkLiteral;
        in
        {
          "*" = {
            text-color = mkLiteral "#${config.colorScheme.palette.base07}";
            background-color = mkLiteral "#${config.colorScheme.palette.base00}";
            border-color = mkLiteral "#${config.colorScheme.palette.base01}";
          };
          "window" = {
            font = "sans 13";
            width = mkLiteral "25%";
          };
          "#mainbox" = {
            padding = mkLiteral "1em";
            border = 7;
          };
          "#inputbar" = {
            children = map mkLiteral [ "entry" ];
          };
          "#prompt" = {
            padding = mkLiteral "0.5em 1em";
            text-color = mkLiteral "#${config.colorScheme.palette.base00}";
            background-color = mkLiteral "#${config.colorScheme.palette.base0E}";
            vertical-align = mkLiteral "0.5";
          };
          "#entry" = {
            padding = mkLiteral "0.3em 0";
            vertical-align = mkLiteral "0.5";
            horizontal-align = mkLiteral "0.5";
            text-color = mkLiteral "#${config.colorScheme.palette.base07}";
            border = mkLiteral "0 0 2";
            border-color = mkLiteral "#${config.colorScheme.palette.base07}";
          };
          "#listview" = {
            lines = mkLiteral "7";
            columns = mkLiteral "1";
            padding = mkLiteral "0.5em 0 0";
          };
          "#element" = {
            padding = mkLiteral "0.15em 0";
            # spacing = mkLiteral "0.5em";
          };
          "element normal.normal, element alternate.normal" = {
            text-color = mkLiteral "#${config.colorScheme.palette.base03}";
            # text-transform = mkLiteral "bold";
          };
          "#element selected.normal" = {
            text-color = mkLiteral "#${config.colorScheme.palette.base0D}";
            # text-transform = mkLiteral "bold";
          };
          "#element-icon" = {
            size = mkLiteral "32";
            vertical-align = mkLiteral "0.5";
          };
          "#element-text" = {
            text-color = mkLiteral "inherit";
            background-color = mkLiteral "inherit";
            text-transform = mkLiteral "inherit";
            vertical-align = mkLiteral "0.5";
            horizontal-align = mkLiteral "0.5";
          };
        };
    };
  };
}
