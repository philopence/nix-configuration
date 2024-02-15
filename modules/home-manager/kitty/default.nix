{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.features.kitty;
in

{
  options.features.kitty = {
    enable = mkEnableOption "";
  };

  config = mkIf cfg.enable {
    programs.kitty = {
      enable = true;
      theme = "Catppuccin-Mocha";
      keybindings = {
        ## CLI
        "ctrl+shift+e" = "launch --cwd=current --type=os-window --os-window-class=lf lf";
        "ctrl+shift+g" = "launch --cwd=current --type=os-window --os-window-class=lazygit lazygit";
        ## WINDOW
        "ctrl+shift+enter" = "launch --cwd=current";
        "ctrl+shift+up" = "previous_window";
        "ctrl+shift+down" = "next_window";
        "ctrl+shift+alt+up" = "move_window_backward";
        "ctrl+shift+alt+down" = "move_window_forward";
        "ctrl+shift+d" = "detach_window ask";
        "ctrl+shift+alt+x" = "launch --cwd=current --location=hsplit";
        "ctrl+shift+alt+v" = "launch --cwd=current --location=vsplit";
        "ctrl+shift+alt+s" = "swap_with_window";
        # "ctrl+shift+f" = "detach_window tab-right";
        # "ctrl+shift+b" = "detach_window tab-left";
        ## TAB
        "ctrl+shift+t" = "combine : new_tab_with_cwd : set_tab_title ' '";
        "ctrl+shift+left" = "previous_tab";
        "ctrl+shift+right" = "next_tab";
        "ctrl+shift+alt+left" = "move_tab_forward";
        "ctrl+shift+alt+right" = "move_tab_backward";
        "ctrl+shift+r" = "set_tab_title";
        "ctrl+shift+w" = "close_tab";
      };
      settings = with config.colorScheme.colors; {
        font_size = "12.0";
        # background_opacity = "0.93";
        # font_family = "Sarasa Term SC";
        # bold_font = "Sarasa Term SC Bold";
        # italic_font = "Sarasa Term SC";
        # bold_italic_font = "Sarasa Term SC Bold";
        "modify_font cell_height" = "105%";
        #
        font_family = "IBM Plex Mono";
        bold_font = "IBM Plex Mono Bold";
        italic_font = "IBM Plex Mono Italic";
        bold_italic_font = "IBM Plex Mono Bold Italic";
        #
        # font_family = "Rec Mono Casual";
        # bold_font = "Rec Mono Casual Bold";
        # italic_font = "Rec Mono Casual Italic";
        # bold_italic_font = "Rec Mono Casual Bold Italic";
        #
        # font_family = "Cascadia Code Regular";
        # bold_font = "Cascadia Code Bold";
        # italic_font = "Cascadia Code Italic";
        # bold_italic_font = "Cascadia Code Bold Italic";

        # https://github.com/ryanoasis/nerd-fonts/blob/master/bin/scripts/test-fonts.sh
        # Nerd Fonts Version: 3.0.2
        # Script Version: 1.1.1
        symbol_map = "U+E000-U+E00D,U+E0A0-U+E0A2,U+E0B0-U+E0B3,U+E0A3-U+E0A3,U+E0B4-U+E0C8,U+E0CC-U+E0D2,U+E0D4-U+E0D4,U+E5FA-U+E62B,U+E700-U+E7C5,U+F000-U+F2E0,U+E200-U+E2A9,U+F400-U+F4A8,U+2665-U+2665,U+26A1-U+26A1,U+F27C-U+F27C,U+F300-U+F32F,U+23FB-U+23FE,U+2B58-U+2B58,U+F0001-U+F0010,U+E300-U+E3EB Symbols Nerd Font Mono";

        window_padding_width = 5;
        window_border_width = "2pt";
        enabled_layouts = "fat:bias=70,tall,splits,grid,horizontal,vertical,stack";
        active_border_color = "#${base0D}";
        inactive_border_color = "#${base03}";
        # tab_activity_symbol = "❥";
        # tab_title_template = "{fmt.fg.red}{bell_symbol}{activity_symbol}{fmt.fg.tab}{title}";
        ##
        # foreground = "#${base06}";
        # background = "#${base00}";
        # selection_foreground = "#${base06}";
        # selection_background = "#${base02}";
        # cursor = "#${base06}";
        # cursor_text_color = "#${base00}";
        # url_color = "#${base0E}";
        # bell_border_color = "#${base0A}";
        # visual_bell_color = "#none";
        # wayland_titlebar_color = "#system";
        # macos_titlebar_color = "#system";
        # active_tab_foreground = "#${base00}";
        # active_tab_background = "#${base09}";
        # inactive_tab_foreground = "#${base03}";
        # inactive_tab_background = "#${base01}";
        # tab_bar_background = "#none";
        # tab_bar_margin_color = "#none";
        # mark1_foreground = "#${base00}";
        # mark1_background = "#${base00}";
        # mark2_foreground = "#${base00}";
        # mark2_background = "#${base00}";
        # mark3_foreground = "#${base00}";
        # mark3_background = "#${base00}";
        # color0 = "#${base00}";
        # color8 = "#${base02}";
        # color1 = "#${base08}";
        # color9 = "#${base08}";
        # color2 = "#${base0B}";
        # color10 = "#${base0B}";
        # color3 = "#${base0A}";
        # color11 = "#${base0A}";
        # color4 = "#${base0D}";
        # color12 = "#${base0D}";
        # color5 = "#${base0E}";
        # color13 = "#${base0E}";
        # color6 = "#${base0C}";
        # color14 = "#${base0C}";
        # color7 = "#${base05}";
        # color15 = "#${base07}";
        # color16 = "#${base0E}";
        # color17 = "#${base0E}";
      };
    };
  };
}
