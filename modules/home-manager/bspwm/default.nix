{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.features.bspwm;
in {
  options.features.bspwm = {
    enable = mkEnableOption "TEMPLATE";
  };

  config = mkIf cfg.enable {
    xsession.windowManager.bspwm = {
      enable = false;
      monitors = {
        eDP-1 = ["1" "2" "3" "4" "5" "6" "7"];
      };
      rules = {
        "kitty" = {
          desktop = "^1";
        };
        "Chromium-browser" = {
          desktop = "^2";
        };
      };
      settings = {
        border_width = 0;
        normal_border_color = "#${config.colorScheme.palette.base00}";
        focused_border_color = "#${config.colorScheme.palette.base02}";
        window_gap = 5;
        split_ratio = 0.50;
        borderless_monocle = true;
        gapless_monocle = true;
      };
      startupPrograms = [];
    };

    services.sxhkd = {
      enable = true;
      keybindings =
        # let
        #   resize = pkgs.writeShellScript "resize" (builtins.readFile ./resize_move.sh);
        # in
        {
          "super + Escape" = "pkill -USR1 -x sxhkd";
          "super + {comma,period}" = "wpctl set-volume @DEFAULT_AUDIO_SINK@ {3%-,3%+}";
          "XF86AudioMute" = "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
          "{XF86MonBrightnessDown,XF86MonBrightnessUp}" = "brightnessctl set {5%-,5%+}";
          "{XF86AudioLowerVolume,XF86AudioRaiseVolume}" = "wpctl set-volume @DEFAULT_AUDIO_SINK@ {3%-,3%+}";
          "super + {_,shift + }Return" = "{kitty -o allow_remote_control=yes,rofi -show drun}";
          "super + m" = "kitty --class btop btop";
          "super + {_,shift + }p" = "maim -o {-s ,_}~/Pictures/screenshot_$(date +%s).png";

          "super + w" = "bspc node focused --close";
          "super + {Up,Down}" = "bspc node focused --focus {prev,next}.leaf.local.!hidden";
          "super + {Left,Right}" = "bspc desktop focused --focus {prev,next}.local";
          "super + shift + {Up,Down}" = "bspc node focused --swap {prev,next}.leaf.local.!hidden";
          "super + shift + {Left,Right}" = "bspc node focused --to-desktop {prev,next}.local --follow";
          "super + {t,shift + t,f,shift + f}" = "bspc node --state {tiled,pseudo_tiled,floating,fullscreen}";
          # "super + alt + {Left,Down,Up,Right}" = "bspc node focused --move {-20 0,0 20,0 -20,20 0}";
          # "super + ctrl + {Left,Down,Up,Right}" = "${resize} {-l,-d,-u,-r}";
          # "super + c" = "${resize} -c";
          # "super + p" = "maim -s ~/Pictures/screenshot_$(date +%s).png";
          # "super + shift + p" = "maim ~/Pictures/desktop_$(date +%s).png";
        };
    };
  };
}
