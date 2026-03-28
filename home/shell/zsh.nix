{ config, ... }: {
  programs = {
    zsh = {
      enable = true;
      dotDir = "${config.home.homeDirectory}/.config/zsh";

      enableCompletion = true;
      autosuggestion.enable = true;
      syntaxHighlighting = {
        enable = true;
      };

      history = {
        save = 10000;
        size = 10000;
        path = "${config.home.homeDirectory}/.cache/zsh_history";
      };

      initContent = ''
        bindkey '^[[1;5C' forward-word # Ctrl+RightArrow
        bindkey '^[[1;5D' backward-word # Ctrl+LeftArrow

        zstyle ':completion:*' completer _complete _match _approximate
        zstyle ':completion:*:match:*' original only
        zstyle ':completion:*:approximate:*' max-errors 1 numeric
        zstyle ':completion:*' menu select
        zstyle ':completion:*' list-colors "''${(s.:.)LS_COLORS}"

        export EDITOR=vim

        # Detect SSH session
        if [ -n "$SSH_CLIENT" ] || [ -n "$SSH_TTY" ]; then
          IS_REMOTE=true
        fi

        _set_title_internal() {
          if [ -n "$TMUX" ]; then
            # In tmux, set pane title without prefix/suffix.
            local title_str="$(print -Pn "$1")"
            printf "\033]2;%s\007" "$title_str"
            # zsh can set title directly with pass-through but then
            # it won't be updated on tmux navigation.
            # printf "\033Ptmux;\033\033]2;%s\007\033\\" "$title_str"
          else
            local prefix=""
            local suffix=" - Terminal"
            [ "$IS_REMOTE" = "true" ] && prefix="$USER@%m: "

            local title_str="$(print -Pn "$prefix$1$suffix")"
            printf "\033]2;%s\007" "$title_str"
          fi
        }

        # Function to set title to current directory (Idle).
        _set_title_precmd() {
          _set_title_internal "%~"
        }

        # Function to set title to running command (Executing).
        _set_title_preexec() {
          _set_title_internal "$1"
        }

        autoload -Uz add-zsh-hook
        add-zsh-hook precmd _set_title_precmd
        add-zsh-hook preexec _set_title_preexec
      '';
    };
  };
  catppuccin.zsh-syntax-highlighting.enable = true;
}
