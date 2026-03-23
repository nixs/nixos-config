{ pkgs, self, desktop, inputs, unstable, ... }:
let
  theme = import "${self}/lib/theme" { inherit pkgs; };
in
{
  imports = [
    (./. + "/${desktop}")

    ./gtk.nix
    ./kitty.nix
    ./mako.nix
    ./qt.nix
    ./rofi.nix
    ./hyprlock.nix
    ./waybar.nix
    ./wl-common.nix
  ];

  programs = {
  };

  home.packages = with pkgs; [
    catppuccin-gtk
    desktop-file-utils
    libnotify
    nautilus
    theme.fonts.default.package
    theme.fonts.emoji.package
    theme.fonts.iconFont.package
    theme.fonts.monospace.package
    xdg-utils
  ];

  fonts.fontconfig.enable = true;
}
