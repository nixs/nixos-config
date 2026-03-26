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
        # grace = 5;
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
          font_color = "rgb(138, 173, 244)";
          placeholder_text = "";
          position = "0, -100";
        }
      ];

      label = [
        {
          text = "$TIME12";
          color = "rgba(202, 211, 245, 1.0)";
          font_family = theme.fonts.default.name;
          font_size = 64;
          text_align = "center";
          halign = "center";
          valign = "center";
          position = "0, 160";
        }
        {
          text = ''cmd[update:60000] echo "$(date +"%a, %b %d")"'';
          color = "rgba(184, 192, 224, 1.0)";
          font_family = theme.fonts.default.name;
          font_size = 24;
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
        # Needed for Niri.
        inhibit_sleep = 1;

        lock_cmd = "pidof hyprlock || hyprlock";
        before_sleep_cmd = "loginctl lock-session";
        after_sleep_cmd = "${pkgs.niri}/bin/niri msg action power-on-monitors";
      };

      listener = [
        {
          # Lock screen after 2 minutes
          timeout = 120;
          on-timeout = "loginctl lock-session";
        }
        {
          # Turn off monitors after 5.5 minutes
          timeout = 305;
          on-timeout = "${pkgs.niri}/bin/niri msg action power-off-monitors";
          on-resume = "${pkgs.niri}/bin/niri msg action power-on-monitors";
        }
        {
          # Suspend after 10 minutes
          timeout = 600;
          on-timeout = "systemctl suspend";
        }
      ];
    };
  };
}
