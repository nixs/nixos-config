{ lib, ... }:
let
  ripgrepCommand = "rg --files --hidden --follow --glob \"!.git/*\"";
in
{
  programs.fzf = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;

    changeDirWidgetOptions = [ "--preview 'tree -C {} | head -200'" ];

    defaultCommand = ripgrepCommand;
    defaultOptions = [
      "--height 90%"
      "--border"
    ];

    fileWidgetCommand = ripgrepCommand;
    fileWidgetOptions = [
      "--preview 'bat -n --style=numbers --color=always --line-range :500 {}'"
      "--bind 'ctrl-/:change-preview-window(down|hidden|)'"
    ];

    tmux.enableShellIntegration = true;
  };
  catppuccin.fzf.enable = true;
}
