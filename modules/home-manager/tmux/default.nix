{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.features.tmux;
in {
  options.features.tmux = {
    enable = mkEnableOption "tmux";
  };

  config = mkIf cfg.enable {
    programs.tmux = {
      enable = false;
      baseIndex = 1;
      clock24 = true;
      escapeTime = 0;
      prefix = "C-Space";
      extraConfig = ''
        DATE="%a %b %d %H:%M %p"
        PREFIX="#{?client_prefix,#[fg=red],#[fg=white]}"
        CWD="#{?client_prefix,#[bg=red],#[bg=white]}#[fg=black#,bold]  #(basename #{pane_current_path}) #[default]"
        WINDOW="#[fg=white] #I #F #W #[default]"
        CURRENT_WINDOW="#[fg=blue#,bold#,italics] #I #F #W #[default]"
        SESSION="#[fg=black#,bg=white#,bold] #S #[default]"
        set -g status-interval 1
        set -g status-position bottom
        set -g status-style "default"
        set -g status-left-length 50
        set -g status-left "$CWD "
        set -g status-right "$DATE $SESSION"
        ##
        set -g window-status-format "$WINDOW"
        set -g window-status-current-format "$CURRENT_WINDOW"
        # set -g window-status-separator " "
        ##
        set -g pane-border-style "fg=white"
        set -g pane-active-border-style "fg=blue"
        ##
        set -g message-style "fg=yellow"
        set -g message-command-style "fg=red"
        ##
        set -g default-terminal "tmux-256color"
        set -sa terminal-features ',XXX:RGB'
        set -g renumber-windows on
        set -g mode-keys vi
        bind : command-prompt -p "COMMAND:"
        bind -n M-j select-pane -t ":.{next}"
        bind -n M-k select-pane -t ":.{previous}"
        bind -n M-h previous-window
        bind -n M-l next-window
        bind x split-window -v -c "#{pane_current_path}"
        bind v split-window -h -c "#{pane_current_path}"
        bind r command-prompt -I "#W" "rename-window '%%'"
        bind c command-prompt "new-window -c '#{pane_current_path}' -n '%%'"
        bind q kill-pane
        bind Q kill-window
        bind -r H swap-window -d -t ":{previous}"
        bind -r L swap-window -d -t ":{next}"
        bind -r M-h resize-pane -L 2
        bind -r M-j resize-pane -D 2
        bind -r M-k resize-pane -U 2
        bind -r M-l resize-pane -R 2
      '';
    };
  };
}
