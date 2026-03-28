{ pkgs, self, ... }:
let
  theme = import "${self}/lib/theme" { inherit pkgs; };
in
{
  catppuccin.kitty = {
    enable = true;
    flavor = "macchiato";
  };

  programs.kitty = {
    enable = true;
    font.name = "${theme.fonts.monospace.name}";
    font.size = 12;
    settings = {
      shell = "zsh";
      background_opacity = "1.0";
      window_padding_width = 4;
      enable_audio_bell = false;
      clipboard_control = "write-clipboard write-primary";
    };
    shellIntegration.mode = "enabled no-sudo no-title";
    shellIntegration.enableBashIntegration = true;
    shellIntegration.enableZshIntegration = true;
  };
}
