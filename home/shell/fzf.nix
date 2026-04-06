{ lib, pkgs, ... }:
let
  ripgrepCommand = "rg --files --hidden --follow --glob '!.git/*'";
  previewScript = pkgs.writeShellScript "fzf-preview" ''
    FILE="$1"
    MIME_TYPE=$(file --mime-type -b "$FILE")

    if [[ "$MIME_TYPE" =~ ^image/ ]]; then
        kitty +kitten icat --clear --stdin=no --place="''${FZF_PREVIEW_COLUMNS}x''${FZF_PREVIEW_LINES}@0x0" --transfer-mode=file "$FILE"
    else
        bat -n --style=numbers --color=always --line-range :500 "$FILE"
    fi
  '';
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
      "--preview '${previewScript} {}'"
      "--bind 'ctrl-/:change-preview-window(down|hidden|)'"
    ];

    tmux.enableShellIntegration = true;
  };
  catppuccin.fzf.enable = true;
}
