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
      '';
    };
  };
  catppuccin.zsh-syntax-highlighting.enable = true;
}
