{
  self,
  lib,
  pkgs,
  ...
}:
let
  theme = import "${self}/lib/theme" { inherit pkgs; };
in
{
  programs.hyprlock = {
    enable = true;
    settings = {
      general = {
        grace = 5;
        hide_cursor = true;
      };

      background = [
        {
          #path = "${theme.wallpaper}";
          blur_passes = 2;
          blur_size = 6;
        }
      ];

      input-field = [
        {
          size = "250, 60";
          outer_color = "rgb(24, 25, 38)";
          inner_color = "rgb(30, 32, 48)";
          font_color = "rgb(198, 160, 246)";
          placeholder_text = "";
        }
      ];

      label = [
        {
          text = "Hello";
          color = "rgba(202, 211, 245, 1.0)";
          font_family = theme.fonts.default.name;
          font_size = 64;
          text_align = "center";
          halign = "center";
          valign = "center";
          position = "0, 160";
        }
        {
          text = "$TIME";
          color = "rgba(184, 192, 224, 1.0)";
          font_family = theme.fonts.default.name;
          font_size = 32;
          text_align = "center";
          halign = "center";
          valign = "center";
          position = "0, 75";
        }
      ];
    };
  };

  services.hypridle = {
    enable = true;
    settings = {
      general = {
        lock_cmd = "/usr/bin/hyprlock";
        before_sleep_cmd = "/usr/bin/hyprlock";
      };

      listener = [
        {
          timeout = 300;
          on-timeout = "/usr/bin/hyprlock";
        }
        {
          timeout = 305;
          on-timeout = "${pkgs.niri}/bin/niri msg action power-off-monitors";
          on-resume = "${pkgs.niri}/bin/niri msg action power-on-monitors";
        }
      ];
    };
  };
}
