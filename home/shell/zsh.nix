{ config, pkgs,  ... }: {
  home.packages = with pkgs; [
    zsh-fzf-tab
  ];

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
        source ${pkgs.zsh-fzf-tab}/share/fzf-tab/fzf-tab.plugin.zsh

        bindkey '^[[1;5C' forward-word # Ctrl+RightArrow
        bindkey '^[[1;5D' backward-word # Ctrl+LeftArrow

        zstyle ':completion:*' completer _complete _match _approximate
        zstyle ':completion:*:match:*' original only
        zstyle ':completion:*:approximate:*' max-errors 1 numeric

        zstyle ':completion:*' menu select
        # Group results by category (e.g., Files, Directories, Commands)
        zstyle ':completion:*' group-name '''
        zstyle ':completion:*:descriptions' format '%F{yellow}-- %d --%f'
        zstyle ':completion:*' list-colors "''${(s.:.)LS_COLORS}"

        zstyle ':fzf-tab:complete:*:*' fzf-preview '[[ -d $realpath ]] && ls -1 --color=always $realpath || bat --color=always --style=numbers $realpath'

        # Kill command: autocomplete process IDs with colors and info
        zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
        zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'

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

        # Search for text INSIDE files interactively
        # Usage: frg <search_term>
        frg() {
          rg --column --line-number --no-heading --color=always --smart-case --glob '!.git/*' "$1" | \
          fzf --ansi \
              --reverse \
              --delimiter : \
              --preview 'bat --style=numbers --color=always --highlight-line {2} {1}' \
              --preview-window 'up,60%,border-bottom,+{2}+3/3,~3' \
              --bind "enter:become(vim {1} +{2})"
        }

        # Use zoxide + fzf for a smarter Alt+C
        j() {
          local dir
          # Query zoxide for all tracked directories, pipe to fzf
          dir=$(zoxide query -l | fzf --height 40% --reverse --border \
            --preview 'ls -F --color=always {} | head -20' \
            --header "Jump to Frequent Directory")

          if [[ -n "$dir" ]]; then
            cd "$dir"
          fi
        }

        # Bind it to Alt+C (or any key you prefer)
        bindkey -s '\ec' 'j\n'
      '';
    };
  };
  catppuccin.zsh-syntax-highlighting.enable = true;
}
