{ pkgs, self, config, inputs, desktop, lib, ... }:
let
  modules =
    [
      "battery"
      "custom/separator"
      "wireplumber"
      "pulseaudio#source"
      "custom/separator"
      "network"
      "bluetooth"
      "custom/separator"
      "tray"
      "idle_inhibitor"
      "group/group-power"
    ];

  workspaceConfig = {
    format = "{icon}";
    format-icons = {
      "1:main" = "󰋜";
      "2:code" = "";
      "3:remote" = "󰢹";
      "default" = " ";
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
  home.packages = with pkgs; [
    blueman
  ];

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

        modules-left = [
          "group/web-apps"
          (if desktop == "hyprland" then "hyprland/workspaces" else "niri/workspaces")
        ];
        modules-center = [ "clock" ];
        modules-right = [ "group/group-right" ];

        "hyprland/workspaces" = workspaceConfig;
        "niri/workspaces" = workspaceConfig;

        "group/group-right" = {
          orientation = "inherit";
          modules = modules;
        };

        "network" = {
          format-wifi = "󰖩 <span font='9' weight='bold' rise='500'>{essid}</span>";
          format-ethernet = "󰌗";
          format-disconnected = "󰌙";
          tooltip-format = "{ifname} / {essid} ({signalStrength}%) / {ipaddr}";
          max-length = 15;
          on-click = "nm-connection-editor";
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
          format = "{icon}  <span font='9' weight='bold' rise='500'>{capacity}%</span>";
          format-alt = "{icon}  <span font='9' weight='bold' rise='500'>{time}</span>";
          format-charging = "󱐋 <span font='9' weight='bold' rise='500'>{capacity}%</span>";
          format-plugged = "󱐋 <span font='9' weight='bold' rise='500'>{capacity}%</span>";
          format-full = "󱐋";
          tooltip-format = "{time} ({capacity}%)";
          format-icons = [
            ""
            ""
            ""
            ""
            ""
          ];
        };

        "tray" = {
          icon-size = 14;
          icon-theme = "Papirus";
          spacing = 8;
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
          on-click = "${pkgs.hyprlock}/bin/hyprlock";
          tooltip = false;
        };

        "custom/reboot" = {
          format = "󰜉";
          on-click = "${pkgs.systemd}/bin/systemctl reboot";
          tooltip = false;
        };

        "custom/power" = {
          format = "󰐥";
          on-click = "${pkgs.systemd}/bin/systemctl poweroff";
          tooltip = false;
        };

        "custom/separator" = {
          format = "|";
          interval = "once";
          tooltip = false;
        };

        "clock" = {
          format = "{:%a, %b %d   %I:%M%p}";
        };

        "wireplumber" = {
          format = "{icon} <span font='9' weight='bold' rise='500'>{volume}%</span>";
          format-muted = "<span color='#f38ba8'>󰝟</span>";
          on-click = "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
          on-click-right = "${lib.getExe pkgs.pwvucontrol}";
          format-icons = {
            headphone = "";
            hands-free = "";
            headset = "";
            phone = "";
            portable = "";
            car = "";
            default = [ "󰕿" "󰖀" "󰕾" ];
          };
          tooltip-format = "{volume}% / {node_name}";
        };

        "pulseaudio#source" = {
          format = "{format_source}";
          format-source = "󰍬";
          format-source-muted = "󰍭";
          on-click = "wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle";
          on-click-right = "${lib.getExe pkgs.pwvucontrol}";
          tooltip-format = "{source_volume}% / {desc}";
        };

        "bluetooth" = {
          format-on = "";
          format-connected = " {device_alias}";
          format-off = "";
          format-disabled = "";
          on-click-right = "${lib.getExe' pkgs.blueman "blueman-manager"}";
          on-click = "${lib.getExe bluetoothToggle}";
        };
      };
    };
    style = ''
      @import "waybar2.rasi";

    '';
  };

  xdg.configFile = {
    "waybar/waybar.rasi".source = ./waybar.rasi;
    "waybar/waybar2.rasi".source = ./waybar2.rasi;
  };
}
