{
  lib,
  pkgs,
  self,
  ...
}:
let
  theme = import "${self}/lib/theme" { inherit pkgs; };
in
{
  catppuccin.swaylock.enable = true;
  catppuccin.swaylock.flavor = "macchiato";

  programs.swaylock = {
    enable = true;
    # package = pkgs.swaylock-effects;

    settings = {
      font = "${theme.fonts.default.name}";
      ignore-empty-password = true;
      indicator-idle-visible = true;
      disable-caps-lock-text = true;

      # swaylock-effects only.
      # clock = "true";
      # indicator = "true";
      # timestr = "%R";
      # datestr = "%a, %e of %B";
      # image = "${theme.wallpaper}";
      # effect-blur = "30x3";
    };
  };

  services.swayidle = {
    enable = true;
    extraArgs = [ "-w" ];
    events = [
      {
        event = "before-sleep";
        command = "/usr/bin/swaylock -f";
      }
      {
        event = "lock";
        command = "/usr/bin/swaylock -f";
      }
    ];
    timeouts = [
      {
        timeout = 300;
        command = "/usr/bin/swaylock -f";
      }
      {
        timeout = 305;
        command = "${pkgs.niri}/bin/niri msg action power-off-monitors";
        resumeCommand = "${pkgs.niri}/bin/niri msg action power-on-monitors";
      }
    ];
  };
}
