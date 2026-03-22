{ pkgs, self, ... }:
let
  theme = import "${self}/lib/theme" { inherit pkgs; };
in
{
  catppuccin.mako.enable = true;

  services.mako = {
    enable = true;
    settings = {
      actions = true;
      anchor = "top-right";
      border-size = 1;
      border-radius = 8;
      default-timeout = 5000; # milliseconds
      font = "${theme.fonts.default.name}";
      icon-path = "${theme.iconTheme.iconPath}";
      icons = true;
      layer = "overlay";
      max-visible = 3;
      padding = "10";
      width = 300;
    };
  };
}

