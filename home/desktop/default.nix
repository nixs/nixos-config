{ pkgs, self, desktop, inputs, unstable, ... }:
let
  theme = import "${self}/lib/theme" { inherit pkgs; };
in
{
  imports = [
    #(./. + "/${desktop}")

    ./rofi.nix
    ./gtk.nix
    ./qt.nix
  ];

  programs = {
  };

  home.packages = with pkgs; [
    catppuccin-gtk
    desktop-file-utils
    libnotify
    xdg-utils
    theme.fonts.default.package
    theme.fonts.emoji.package
    theme.fonts.iconFont.package
    theme.fonts.monospace.package
  ];

  fonts.fontconfig.enable = true;
}
