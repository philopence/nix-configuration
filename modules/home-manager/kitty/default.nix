{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.features.kitty;
in {
  options.features.kitty = {
    enable = mkEnableOption "";
  };

  config = mkIf cfg.enable {
    programs.kitty = {
      enable = true;
      keybindings = {
        ## CLI
        "ctrl+shift+g" = "launch --cwd=current --type=os-window --os-window-class=lazygit lazygit";
        ## WINDOW
        # "ctrl+shift+enter" = "launch --cwd=current";
        "ctrl+shift+up" = "previous_window";
        "ctrl+shift+down" = "next_window";
        "alt+shift+up" = "move_window_backward";
        "alt+shift+down" = "move_window_forward";
        "ctrl+shift+x" = "launch --cwd=current --location=hsplit"; # splits
        "ctrl+shift+v" = "launch --cwd=current --location=vsplit"; # splits
        "super+c" = "copy_to_clipboard";
        "super+v" = "paste_from_clipboard";
        "super+s" = "paste_from_selection";
        "ctrl+shift+space" = "toggle_layout stack";
        "ctrl+shift+w" = "focus_visible_window";
        ## TAB
        # "ctrl+shift+t" = "combine : new_tab_with_cwd : set_tab_title ' '";
        "ctrl+shift+tab" = "select_tab";
        "ctrl+shift+left" = "previous_tab";
        "ctrl+shift+right" = "next_tab";
        "alt+shift+left" = "move_tab_backward";
        "alt+shift+right" = "move_tab_forward";
        "ctrl+shift+t" = "new_tab_with_cwd";
        "ctrl+shift+r" = "set_tab_title";
      };
      settings = {
        enabled_layouts = "splits,stack";
        # tab_bar_style = "hidden";
        background_opacity = "1.0";
        window_padding_width = 15;
        window_border_width = 1;
        cursor_stop_blinking_after = 0;
        font_size = "10.0";
        "modify_font cell_height" = "1.5";
        "modify_font underline_position" = "2";
        "modify_font underline_thickness" = "150%";
        #
        font_family = "Cascadia Code Regular";
        bold_font = "Cascadia Code Bold";
        italic_font = "Cascadia Code Italic";
        bold_italic_font = "Cascadia Code Bold Italic";
        "font_features CascadiaCode-Bold" = "+zero +ss01 +calt";
        "font_features CascadiaCode-Regular" = "+zero +ss01 +calt";
        "font_features CascadiaCode-Italic" = "+zero +ss01 +calt";
        "font_features CascadiaCode-BoldItalic" = "+zero +ss01 +calt";

        symbol_map = "U+23FB-U+23FE,U+2665,U+26A1,U+2B58,U+E000-U+E00A,U+E0A0-U+E0A2,U+E0A3,U+E0B0-U+E0B3,U+E0B4-U+E0C8,U+E0CA,U+E0CC-U+E0D7,U+E200-U+E2A9,U+E300-U+E3E3,U+E5FA-U+E6B5,U+E700-U+E7C5,U+EA60-U+EC1E,U+ED00-U+EFC1,U+F000-U+F2FF,U+F300-U+F372,U+F400-U+F533,U+F0001-U+F1AF0 Symbols Nerd Font Mono";
        active_border_color = "#ff9e64";
        inactive_border_color = "#ff9e64";
        active_tab_foreground = "#1a1b26";
        active_tab_background = "#7aa2f7";
        inactive_tab_foreground = "#565f89";
        inactive_tab_background = "#283457";
        foreground = "#c0caf5";
        background = "#1a1b26";
        selection_foreground = "none";
        selection_background = "#283457";
        url_color = "#73daca";
        cursor = "none";
        # cursor = "#c0caf5";
        # cursor_text_color = "#1a1b26";
        color0 = "#15161e";
        color1 = "#f7768e";
        color2 = "#9ece6a";
        color3 = "#e0af68";
        color4 = "#7aa2f7";
        color5 = "#bb9af7";
        color6 = "#7dcfff";
        color7 = "#a9b1d6";
        color8 = "#414868";
        color9 = "#f7768e";
        color10 = "#9ece6a";
        color11 = "#e0af68";
        color12 = "#7aa2f7";
        color13 = "#bb9af7";
        color14 = "#7dcfff";
        color15 = "#c0caf5";
        color16 = "#ff9e64";
        color17 = "#db4b4b";
      };
    };
  };
}
