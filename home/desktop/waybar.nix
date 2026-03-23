{ pkgs, self, config, inputs, desktop, lib, ... }:
let
  modules =
    [
      "network"
      "battery"
      "wireplumber"
      "pulseaudio#source"
      "bluetooth"
      "clock"
      "idle_inhibitor"
      "tray"
      "group/group-power"
    ];

  workspaceConfig = {
    format = "{icon}";
    format-icons = {
      #"1" = "";
      #"2" = "";
      #"3" = "󰙀";
      #"4" = "";
      #"5" = "";
      #"6" = "";
      #"7" = "";
    };
    on-click = "activate";
  };
  
  bluetoothToggle = pkgs.writeShellApplication {
    name = "bluetooth-toggle";
    runtimeInputs = with pkgs; [
      gnugrep
      bluez
    ];
    text = ''
      if [[ "$(bluetoothctl show | grep -Po "Powered: \K(.+)$")" =~ no ]]; then
        bluetoothctl power on
        bluetoothctl discoverable on
      else
        bluetoothctl power off
      fi
    '';
  };

  theme = import "${self}/lib/theme" { inherit pkgs; };
in
{
  programs.waybar = {
    enable = true;
    systemd.enable = false;  # Spawned by niri instead.
    settings = {
      mainBar = {
        exclusive = true;
        position = "top";
        layer = "top";
        height = 18;
        passthrough = false;
        gtk-layer-shell = true;

        modules-left = [ (if desktop == "hyprland" then "hyprland/workspaces" else "niri/workspaces") ];
        modules-center = [ "niri/window" ];
        modules-right = modules;

        "hyprland/workspaces" = workspaceConfig;
        "niri/workspaces" = workspaceConfig;

        "network" = {
          format-wifi = "{essid} ";
          format-ethernet = "{ifname} ";
          format-disconnected = "";
          tooltip-format = "{ifname} / {essid} ({signalStrength}%) / {ipaddr}";
          max-length = 15;
          on-click = "${pkgs.kitty}/bin/kitty -e ${pkgs.networkmanager}/bin/nmtui";
        };

        "idle_inhibitor" = {
          format = "{icon}";
          format-icons = {
            activated = "";
            deactivated = "";
          };
        };

        "battery" = {
          states = {
            good = 95;
            warning = 20;
            critical = 10;
          };
          format = "{capacity}% {icon}";
          format-charging = "{capacity}% ";
          format-plugged = "";
          tooltip-format = "{time} ({capacity}%)";
          format-alt = "{time} {icon}";
          format-full = "";
          format-icons = [
            ""
            ""
            ""
            ""
            ""
          ];
        };

        "group/group-power" = {
          orientation = "inherit";
          drawer = {
            transition-duration = 500;
            transition-left-to-right = false;
          };
          modules = [
            "custom/power"
            "custom/quit"
            "custom/lock"
            "custom/reboot"
          ];
        };

        "custom/quit" = {
          format = "󰗼";
          on-click =
            if desktop == "hyprland" then
              "${pkgs.hyprland}/bin/hyprctl dispatch exit"
            else
              "${pkgs.niri}/bin/niri msg action quit";
          tooltip = false;
        };

        "custom/lock" = {
          format = "󰍁";
          on-click =
            if desktop == "hyprland" then
              "${pkgs.hyprlock}/bin/hyprlock"
            else
              "${pkgs.swaylock-effects}/bin/swaylock -f";
          tooltip = false;
        };

        "custom/reboot" = {
          format = "󰜉";
          on-click = "${pkgs.systemd}/bin/systemctl reboot";
          tooltip = false;
        };

        "custom/power" = {
          format = "";
          on-click = "${pkgs.systemd}/bin/systemctl poweroff";
          tooltip = false;
        };

        "clock" = {
          format = "{:%d %b %H:%M}";
        };

        "wireplumber" = {
          format = "{volume}% {icon}";
          format-muted = "";
          on-click = "${lib.getExe pkgs.pwvucontrol}";
          format-icons = [
            ""
            ""
            ""
          ];
          tooltip-format = "{volume}% / {node_name}";
        };

        "pulseaudio#source" = {
          format = "{format_source}";
          format-source = "";
          format-source-muted = "";
          on-click = "${lib.getExe pkgs.pwvucontrol}";
          tooltip-format = "{source_volume}% / {desc}";
        };

        "bluetooth" = {
          format-on = "";
          format-connected = "{device_alias} ";
          format-off = "";
          format-disabled = "";
          on-click-right = "${lib.getExe' pkgs.blueberry "blueberry"}";
          on-click = "${lib.getExe bluetoothToggle}";
        };
      };
    };
    style = ''
      @import "waybar.rasi";

    '';
  };

  xdg.configFile = {
    "waybar/waybar.rasi" = {
      source = ./waybar.rasi;
    };
  };
}
