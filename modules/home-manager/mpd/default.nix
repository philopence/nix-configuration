{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.features.mpd;
in

{
  options.features.mpd = {
    enable = mkEnableOption "TEMPLATE";
  };

  config = mkIf cfg.enable {

    home.packages = with pkgs; [ mpc-cli ];

    programs.ncmpcpp = {
      enable = true;
      package = pkgs.ncmpcpp.override { visualizerSupport = true; };
      settings = {
        visualizer_type = "ellipse";
        visualizer_look = "●●";
        progressbar_look = "━━━";
        header_visibility = "no";
        titles_visibility = "no";
      };
    };

    services.mpd = {
      enable = true;
      extraConfig = ''
        audio_output {
            type            "pipewire"
            name            "PipeWire Sound Server"
        }
        audio_output {
            type                    "fifo"
            name                    "my_fifo"
            path                    "/tmp/mpd.fifo"
            format                  "44100:16:2"
        }
      '';
    };
  };
}
