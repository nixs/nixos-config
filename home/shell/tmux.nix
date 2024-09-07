{ pkgs, ... }:
{
  programs = {
    tmate.enable = true;

    tmux = {
      enable = true;
      catppuccin.enable = true;

      aggressiveResize = true;
      baseIndex = 1;
      clock24 = true;
      sensibleOnTop = true;
      # This should either be screen-256color or tmux-256color where it exists
      terminal = "tmux-256color";
      shell = "${pkgs.zsh}/bin/zsh";
      prefix = "C-Space";

      extraConfig = ''
        set -g status on
        set -g mouse on

        unbind r
        bind r source-file ~/.config/tmux/tmux.conf

        # Prefix then [ to start vi mode
        # Prefix then ] to paste
        set-window-option -g mode-keys vi
        bind-key -T copy-mode-vi 'v' send -X begin-selection # start selecting text with "v"
        bind-key -T copy-mode-vi 'y' send -X copy-selection # copy text with "y"

        # Catppuccin options
        set -g @catppuccin_host 'on'
        set -g @catppuccin_window_tabs_enabled 'on'

        # Smart pane switching with awareness of Vim splits.
        # See: https://github.com/alexghergh/nvim-tmux-navigation
        # based on: https://github.com/christoomey/vim-tmux-navigator

        # decide whether we're in a Vim process
        is_vim="ps -o state= -o comm= -t '#{pane_tty}' \
            | grep -iqE '^[^TXZ ]+ +(\\S+\\/)?g?(view|n?vim?x?)(diff)?$'"

        bind-key -n 'C-h' if-shell "$is_vim" 'send-keys C-h' 'select-pane -L'
        bind-key -n 'C-j' if-shell "$is_vim" 'send-keys C-j' 'select-pane -D'
        bind-key -n 'C-k' if-shell "$is_vim" 'send-keys C-k' 'select-pane -U'
        bind-key -n 'C-l' if-shell "$is_vim" 'send-keys C-l' 'select-pane -R'

        tmux_version='$(tmux -V | sed -En "s/^tmux ([0-9]+(.[0-9]+)?).*/\1/p")'

        if-shell -b '[ "$(echo "$tmux_version < 3.0" | bc)" = 1 ]' \
            "bind-key -n 'C-\\' if-shell \"$is_vim\" 'send-keys C-\\'  'select-pane -l'"
        if-shell -b '[ "$(echo "$tmux_version >= 3.0" | bc)" = 1 ]' \
            "bind-key -n 'C-\\' if-shell \"$is_vim\" 'send-keys C-\\\\'  'select-pane -l'"

        # bind-key -n 'C-Space' if-shell "$is_vim" 'send-keys C-Space' 'select-pane -t:.+'

        bind-key -T copy-mode-vi 'C-h' select-pane -L
        bind-key -T copy-mode-vi 'C-j' select-pane -D
        bind-key -T copy-mode-vi 'C-k' select-pane -U
        bind-key -T copy-mode-vi 'C-l' select-pane -R
        bind-key -T copy-mode-vi 'C-\' select-pane -l
        # bind-key -T copy-mode-vi 'C-Space' select-pane -t:.+

        bind-key h split-window -h -c "#{pane_current_path}" # Split panes horizontal
        bind-key v split-window -v -c "#{pane_current_path}" # Split panes vertically
        bind-key 'M-h' resize-pane -L 5
        bind-key 'M-j' resize-pane -D 5
        bind-key 'M-k' resize-pane -U 5
        bind-key 'M-l' resize-pane -R 5
      '';
    };
  };
}
