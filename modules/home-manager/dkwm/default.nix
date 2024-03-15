{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.features.dkwm;
in

{
  options.features.dkwm = {
    enable = mkEnableOption "";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [ dk sxhkd ];

    # ${pkgs.feh}/bin/feh --no-fehbg --bg-scale ${wallpaper}
    xdg.configFile."dk/dkrc".source = pkgs.writeShellScript "dkrc" ''
      logfile="$HOME/.dkrc.log"
      [ -d "$HOME/.local/share/xorg" ] && logfile="$HOME/.local/share/xorg/dkrc.log"
      : > "$logfile"

      pgrep -x sxhkd > /dev/null || sxhkd &

      xset r rate 200 50

      {
        dkcmd set numws=5
        dkcmd set ws=_ apply layout=tile master=1 stack=5 gap=10 msplit=0.5 ssplit=0.5
        dkcmd set ws=2 gap=0
        dkcmd set focus_open=true focus_urgent=true focus_mouse=false
        dkcmd set tile_tohead=false tile_hints=true
        dkcmd set win_minwh=50 win_minxy=10
        dkcmd set smart_gap=false smart_border=false
        dkcmd set mouse mod=super move=button1 resize=button3
        dkcmd set border width=0 outer_width=7 \
          colour \
          focus='#${config.colorScheme.palette.base07}' \
          unfocus='#${config.colorScheme.palette.base03}' \
          urgent='#${config.colorScheme.palette.base08}' \
          outer_focus='#${config.colorScheme.palette.base00}' \
          outer_unfocus='#${config.colorScheme.palette.base00}' \
          outer_urgent='#${config.colorScheme.palette.base00}'
        dkcmd rule class='^chromium-browser$' ws=2
        # dkcmd rule class="^chromium-browser$" title="^open files$" float=true w=1280 h=720
        dkcmd rule class='^btop$' float=true x=center y=center w=1280 h=720
        dkcmd rule class='^lf$' float=true x=center y=center w=1280 h=720
        dkcmd rule class='^lazygit$' float=true x=center y=center w=1280 h=720
        dkcmd rule class='^ripdrag$' float=true x=center y=center w=1280 h=720
        dkcmd rule apply '*'
        # dkcmd rule remove '*'
      } >> "$logfile" 2>&1

      if grep -q 'error:' "$logfile"; then
        hash notify-send && notify-send -t 0 -u critical "dkrc has errors" \
          "$(awk '/error:/ {sub(/^error: /, ""); gsub(/</, "\<"); print}' "$logfile")"
        exit 1
      fi

      exit 0
    '';

    xdg.configFile."sxhkd/sxhkdrc".text = ''
      super + Escape
        pkill -USR1 -x sxhkd
      ## SYSTEM
      {XF86MonBrightnessDown,XF86MonBrightnessUp}
        brightnessctl set {5%-,5%+}
      {XF86AudioLowerVolume,XF86AudioRaiseVolume}
        wpctl set-volume @DEFAULT_AUDIO_SINK@ {3%-,3%+}
      XF86AudioMute
        wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle
      ## APPLICATION
      super + {_,shift + }Return
        {kitty -o allow_remote_control=yes,rofi -show drun}
      super + m
        kitty --class btop btop
      super + {_,shift + }p
        maim -o {-s ,_}~/Pictures/screenshot_$(date +%s).png
      ## DKWM
      super + {Down,Up}
        dkcmd win focus {next,prev}
      super + shift + {Down,Up}
        dkcmd win mvstack {down,up}
      super + {_,shift + }{Left,Right}
        dkcmd ws {view,follow} {prev,next}
      super + w
        dkcmd win kill
      super + shift + s
        dkcmd win swap
      super + shift + c
        dkcmd win cycle
      super + {f,s}
        dkcmd win {float,stick}
      super + alt + {Left,Down,Up,Right}
        dkcmd win resize {x=-20,y=+20,y=-20,x=+20}
      super + ctrl + {Left,Down,Up,Right,Return}
        dkcmd win resize {w=-20,h=-20,h=+20,w=+20,x=center y=center}
    '';
  };
}
