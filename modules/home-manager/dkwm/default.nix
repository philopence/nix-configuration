{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.features.dkwm;
  focus = "#565f89";
  urgent = "#ff9e64";
  unfocus = "#1a1b26";
  outer = "#1a1b26";
  # bg_highlight = "#292e42",
  # bg_visual = "#283457",
in {
  options.features.dkwm = {
    enable = mkEnableOption "";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [dk sxhkd];

    # ${pkgs.feh}/bin/feh --no-fehbg --bg-scale ${wallpaper}
    xdg.configFile."dk/dkrc".source = pkgs.writeShellScript "dkrc" ''
      logfile="$HOME/.dkrc.log"
      [ -d "$HOME/.local/share/xorg" ] && logfile="$HOME/.local/share/xorg/dkrc.log"
      : > "$logfile"

      pgrep -x sxhkd > /dev/null || sxhkd &

      xset r rate 200 50

      if ! pgrep -f "kitty --class scratchpad" >/dev/null 2>&1; then
        kitty --class scratchpad &
      fi

      {
        dkcmd set numws=5

        dkcmd set ws=_ apply layout=tile master=1 stack=3 gap=15 msplit=0.5 ssplit=0.5

        dkcmd set ws=2 gap=0

        dkcmd set focus_open=true focus_urgent=true focus_mouse=false

        dkcmd set tile_tohead=false tile_hints=true

        dkcmd set win_minwh=50 win_minxy=10

        dkcmd set smart_gap=false smart_border=false

        dkcmd set mouse mod=super move=button1 resize=button3

        dkcmd set border width=0 outer_width=0 colour focus=${focus} urgent=${urgent} unfocus=${unfocus} outer_focus=${outer} outer_urgent=${outer} outer_unfocus=${outer}

        dkcmd rule class="^scratchpad$" scratch=true float=true x=center y=center w=640 h=360
        dkcmd rule class='^(Chromium-browser|Brave-browser)$' ws=2
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
      ## APPLICATION
      super + Escape
        pkill -USR1 -x sxhkd
      super + Return
        kitty -o allow_remote_control=yes
      super + space
        rofi -show drun
      super + Tab
        rofi -show window
      # super + m
      #   kitty --class btop btop
      super + b
        brave
      super + {_,shift + }p
        maim -o {-s ,_}~/Pictures/screenshot_$(date +%s).png

      ## SYSTEM
      {XF86MonBrightnessDown,XF86MonBrightnessUp}
        brightnessctl set {5%-,5%+}
      {XF86AudioLowerVolume,XF86AudioRaiseVolume}
        wpctl set-volume @DEFAULT_AUDIO_SINK@ {3%-,3%+}
      XF86AudioMute
        wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle

      ## DKWM
      super + {Down,Up}
        dkcmd win focus {next,prev}
      super + shift + {Down,Up}
        dkcmd win mvstack {down,up}
      super + {_,shift + }{Left,Right}
        dkcmd ws {view,follow} {prev,next}
      super + w
        dkcmd win kill
      # super + shift + s
      #   dkcmd win swap
      super + shift + c
        dkcmd win cycle
      super + f
        dkcmd win float
      super + u
        dkcmd win scratchpad scratch
      super + ctrl + {Left,Down,Up,Right}
        dkcmd win resize {w=-10,h=-10,h=+10,w=+10}
      super + alt + {Left,Down,Up,Right}
        dkcmd win resize {x=-10,y=+10,y=-10,x=+10}
      super + alt + Return
        dkcmd win resize x=center y=center; dkcmd win resize y=-1
      # HACK: 1280x720 1024x576 768x432 640x360
      #           X        L       M       S
      super + shift + {f,x,l,m,s}
        dkcmd win resize {x=center y=center w=1366 h=768,x=center y=center w=1280 h=720,x=center y=center w=1024 h=576,x=center y=center w=768 h=432,x=center y=center w=640 h=360}; dkcmd win resize y=+1
    '';
  };
}
