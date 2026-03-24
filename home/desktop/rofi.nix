{ pkgs, lib, config, self, ... }:
let
  globalTheme = import "${self}/lib/theme" { inherit pkgs; };
in
{
  catppuccin.rofi = {
    enable = true;
    flavor = "mocha";
  };

  programs.rofi = {
    enable = true;
    package = pkgs.rofi;
    # Terminal override.
    terminal = "${pkgs.kitty}/bin/kitty";

    extraConfig = {
      modi = "drun,window,combi";
      combi-modi = "window,drun";
      show-icons = true;
      drun-display-format = "{icon} {name}";
      disable-history = false;
      hide-scrollbar = true;
      display-combi = " All ";
      display-drun = "   Apps ";
      display-window = "  🗔 Windows ";
      sidebar-mode = true;
    };

    theme = lib.mkForce "rofi-theme.rasi";
  };

  xdg.dataFile = {
    "rofi/themes/rofi-theme.rasi" = {
      text =  ''
        @import "catppuccin-default.rasi"
        @import "catppuccin-mocha.rasi"
        @import "rofi-overrides.rasi"
      '';
    };
    "rofi/themes/rofi-overrides.rasi" = {
      source = ./rofi-overrides.rasi;
    };
  };

  # Add compositor for X11 for transparency.
  services.picom = {
    enable = true;
    backend = "glx";
    vSync = true;
    fade = true;
    inactiveOpacity = 0.9;
  };

  home.packages = [ pkgs.bemoji ];
}
