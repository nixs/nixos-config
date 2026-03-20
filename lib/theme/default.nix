{
  pkgs,
  hostname ? "",
  ...
}:
rec {
  catppuccin = {
    flavor = "macchiato";
    accent = "blue";
    size = "standard";
  };

  gtkTheme = {
    name = "catppuccin-macchiato-blue-standard";
    package = pkgs.catppuccin-gtk.override {
      inherit (catppuccin) size;
      variant = catppuccin.flavor;
      accents = [ catppuccin.accent ];
    };
  };

  qtTheme = {
    name = "Catppuccin-Macchiato-Blue";
    package = pkgs.catppuccin-kvantum.override {
      variant = catppuccin.flavor;
      inherit (catppuccin) accent;
    };
  };

  iconTheme = rec {
    name = "Papirus-Dark";
    package = pkgs.papirus-icon-theme;
    iconPath = "${package}/share/icons/${name}";
  };

  cursorTheme = {
    name = "Adwaita";
    package = pkgs.adwaita-icon-theme;
    size = 24;
  };

  fonts = {
    default = {
      name = "Inter";
      package = pkgs.inter;
      size = "11";
    };
    iconFont = {
      name = "Inter";
      package = pkgs.inter;
    };
    monospace = {
      name = "FiraMono Nerd Font Mono";
      package = pkgs.nerd-fonts.fira-mono;
    };
    emoji = {
      name = "Noto Color Emoji";
      package = pkgs.noto-fonts-color-emoji;
    };
  };
}
