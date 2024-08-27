{
  programs = {
    zsh = {
      enable = true;
      dotDir = ".config/zsh";

      enableCompletion = true;
      autosuggestion.enable = true;
      syntaxHighlighting = {
        enable = true;
        catppuccin.enable = true;
      };

      history = {
        save = 10000;
        size = 10000;
        path = "$HOME/.cache/zsh_history";
      };

      initExtra = ''
        bindkey '^[[1;5C' forward-word # Ctrl+RightArrow
        bindkey '^[[1;5D' backward-word # Ctrl+LeftArrow

        zstyle ':completion:*' completer _complete _match _approximate
        zstyle ':completion:*:match:*' original only
        zstyle ':completion:*:approximate:*' max-errors 1 numeric
        zstyle ':completion:*' menu select
        zstyle ':completion:*' list-colors "''${(s.:.)LS_COLORS}"

        export EDITOR=vim
      '';

      shellAliases = {
        ls = "eza -gl --git --color=automatic";
        tree = "eza --tree";
        cat = "bat";

        ip = "ip --color";
        ipb = "ip --color --brief";

        htop = "btm -b";
        neofetch = "fastfetch";

        ts = "tailscale";
        tst = "tailscale status";
        tsu = "tailscale up --ssh --operator=$USER";
        tsd = "tailscale down";

        speedtest = "curl -s https://raw.githubusercontent.com/sivel/speedtest-cli/master/speedtest.py | python -";

        hm = "nh home switch /home/nick/nixos-config";
      };
    };
  };
}
