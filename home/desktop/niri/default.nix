{
  self,
  config,
  hostname,
  lib,
  pkgs,
  inputs,
  ...
}:
{
  imports = [
    inputs.niri.homeModules.niri
  ];

  home.packages = with pkgs; [
    # X11 Compatibility.
    libxcursor
    libxcb
    libxi
    xwayland-satellite
  ];

  programs.niri.enable = true;
  programs.niri.package = pkgs.niri-stable;

  programs.niri.settings = {
    environment = {
      "LD_LIBRARY_PATH" = "${pkgs.lib.makeLibraryPath (with pkgs; [ 
        libXcursor 
        xwayland-satellite
      ])}";
      "DISPLAY" = ":0";
    };

    prefer-no-csd = true;
    screenshot-path = "~/Pictures/Screenshots/Screenshot-%Y%m%d-%H%M%S.png";

    # Keybindings and behavior
    input = {
      # mod-key = "Alt";
      mod-key = "Super";
      keyboard.xkb.layout = "us";
      touchpad = {
        tap = true;
        dwt = true;
      };
    };
  
    # Layout settings
    layout = {
      gaps = 10;
      center-focused-column = "never";
    };

    outputs = {
      "eDP-1" = {
        mode = { width = 1920; height = 1200; refresh = 60.0; };
        scale = 1.25;
        position = { x = 0; y = 146; };
      };
      "DP-5" = {
        mode = { width = 1920; height = 1200; refresh = 60.0; };
        position = { x = 1536; y = 0; }; # Place next to internal display
        variable-refresh-rate = true;   # Enable VRR/FreeSync
      };
    };

    workspaces = {
      "1:main" = { open-on-output = "eDP-1"; };
      "2:code" = { };
      "3:remote" = { };
    };

    window-rules = [
      {
        clip-to-geometry = true;
        geometry-corner-radius = {
          bottom-left = 8.;
          bottom-right = 8.;
          top-left = 8.;
          top-right = 8.;
        };
        shadow = {
          enable = true;
          softness = 4;
          spread = 0;
          offset = { x = 2; y = 2; };
          color = "#00000080";
          draw-behind-window = true;
        };
      }
      {
        matches = [
          { app-id = "org.gnome.*"; }
          { app-id = "wdisplays"; }
          { app-id = "pinentry-qt"; }
          { app-id = "^code$"; }
        ];
        open-floating = true;
      }
      {
        matches = [
          { app-id = "nm-connection-editor"; }
          { app-id = "pavucontrol"; }
          { app-id = "com.saivert.pwvucontrol"; }
          { app-id = ".*blueman.*"; }
        ];
        open-floating = true;
        default-floating-position = {
          x = 0;
          y = 0;
          relative-to = "top-right";
        };
      }
      {
        matches = [ { title = "Meet - .*"; } ];
        excludes = [ { title = "Google Chrome"; } ];
        open-floating = true;
        default-floating-position = {
          x = 32; 
          y = 32;
          relative-to = "bottom-right";
        };
      }
      {
        matches = [
          { app-id = "chrome-calendar.google.com.*"; }
          { app-id = "chrome-mail.google.com.*"; }
          { app-id = "chrome-meet.google.com.*"; }
        ];
        open-on-workspace = "1:main";
      }
      {
        matches = [ { app-id = "chrome-calendar.*"; } ];
        default-column-width = { proportion = 0.33; };
      }
      {
        matches = [ { app-id = "chrome-cider-v.*"; } ];
        open-on-workspace = "2:code";
      }
      {
        matches = [ { app-id = "chrome-remotedesktop.corp.*"; } ];
        open-on-workspace = "3:remote";
      }
    ];
  
    # Example Keybindings
    binds = with config.lib.niri.actions; {
      "Alt+Shift+Slash" = { action = show-hotkey-overlay; };
      "Alt+Shift+Q" = { action = quit; };
      "Alt+Q" = { action = close-window; repeat = false; };
      "Alt+F4" = { action = close-window; repeat = false; };
      "Alt+XF86AudioMicMute" = { action = close-window; repeat = false; };
      "Alt+O" = { action = toggle-overview; repeat = false; }; 
      "Mod+Escape" = {
        action = toggle-keyboard-shortcuts-inhibit;
        allow-inhibiting = false;
      };
      "Super+L".action.spawn = [ "hyprlock" ];

      "Alt+T" = {
        action.spawn = [ "kitty" "--title=Terminal" ];
        hotkey-overlay.title = "Terminal";
      };
      "Alt+Return" = {
        action.spawn = [ "kitty" "--title=Terminal" ];
        hotkey-overlay.title = "Terminal";
      };
      "Alt+R".action.spawn = [ "rofi" "-show" "run" ];
      "Alt+Space".action.spawn = [ "rofi" "-show" ];
      "Alt+X".action.spawn-sh = "cliphist list | rofi -dmenu | cliphist decode | wl-copy";
      "Alt+B".action.spawn = [ "google-chrome-stable" ];
      "Alt+C".action.spawn = [ "gtk-launch cider" ];

      # Scrolling / Navigation
      "Alt+H".action = focus-column-left;
      "Alt+L".action = focus-column-right;
      "Alt+K".action = focus-window-or-workspace-up;
      "Alt+J".action = focus-window-or-workspace-down;
      "Alt+Shift+H".action = focus-monitor-left;
      "Alt+Shift+L".action = focus-monitor-right;

      # Moving Windows
      "Alt+Ctrl+H".action = move-column-left;
      "Alt+Ctrl+L".action = move-column-right;
      "Alt+Ctrl+K".action = move-window-up-or-to-workspace-up;
      "Alt+Ctrl+J".action = move-window-down-or-to-workspace-down;
      "Alt+Ctrl+Shift+H".action = move-column-to-monitor-left;
      "Alt+Ctrl+Shift+L".action = move-column-to-monitor-right;

      "Alt+BracketLeft".action = consume-window-into-column;
      "Alt+BracketRight".action = expel-window-from-column;
      "Alt+Comma".action = consume-or-expel-window-left;
      "Alt+Period".action = consume-or-expel-window-right;

      # Workspaces
      "Super+1".action = focus-workspace 1;
      "Super+2".action = focus-workspace 2;
      "Super+3".action = focus-workspace 3;
      "Super+4".action = focus-workspace 4;
      "Super+5".action = focus-workspace 5;
      "Super+6".action = focus-workspace 6;
      "Super+7".action = focus-workspace 7;
      "Super+8".action = focus-workspace 8;
      "Super+9".action = focus-workspace 9;
      "Alt+Ctrl+1".action.move-column-to-workspace = 1;
      "Alt+Ctrl+2".action.move-column-to-workspace = 2;
      "Alt+Ctrl+3".action.move-column-to-workspace = 3;
      "Alt+Ctrl+4".action.move-column-to-workspace = 4;

      # Layout Controls
      "Alt+Shift+R".action = switch-preset-column-width;
      "Alt+Ctrl+R".action = reset-window-height;
      "Alt+Shift+F".action = maximize-column;
      "Alt+Ctrl+F".action = fullscreen-window;
      "Alt+W".action = toggle-column-tabbed-display;
      "Alt+V".action = toggle-window-floating;
      "Alt+Shift+Ctrl+V".action = switch-focus-between-floating-and-tiling;

      "Alt+Minus".action.set-column-width = "-10%";
      "Alt+Equal".action.set-column-width = "+10%";

      # Print
      "Print".action.screenshot-screen = { show-pointer = true; };
      "Alt+Print".action.screenshot-window = [];
      "Shift+Print".action.spawn-sh = "grim -g \"$(slurp)\" - | swappy -f -";
      "XF86SelectiveScreenshot".action.spawn-sh = "grim -g \"$(slurp)\" - | swappy -f -";

      # Example volume keys mappings for PipeWire & WirePlumber.
      # The allow-when-locked=true property makes them work even when the session is locked.
      # Using spawn-sh allows to pass multiple arguments together with the command.
      # "-l 1.0" limits the volume to 100%.
      "XF86AudioRaiseVolume" = {
        action = spawn-sh "wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.1+ -l 1.0";
        allow-when-locked = true;
      };
      "XF86AudioLowerVolume" = {
        action = spawn-sh "wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.1-";
        allow-when-locked = true;
      };
      "XF86AudioMute" = {
        action = spawn-sh "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
        allow-when-locked = true;
      };
      "XF86AudioMicMute" = {
        action = spawn-sh "wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle";
        allow-when-locked = true;
      };

      # Example brightness key mappings for brightnessctl.
      # You can use regular spawn with multiple arguments too (to avoid going through "sh"),
      # but you need to manually put each argument in separate "" quotes.
      "XF86MonBrightnessUp" = {
        action = spawn-sh "brightnessctl --class=backlight set +10%";
        allow-when-locked = true;
      };
      "XF86MonBrightnessDown" = {
        action = spawn-sh "brightnessctl --class=backlight set 10%-";
        allow-when-locked = true;
      };
     
      # Open DMS Spotlight/Launcher
      # "Alt+Shift+M".action = spawn "dms" "ipc" "call" "spotlight" "toggle";
      # "Alt+M".action = spawn "dms" "ipc" "call" "spotlight" "toggle";
      # "Mod+M".action = spawn "dms" "ipc" "call" "spotlight" "toggle";
      #     
      # # Open DMS Control Center
      # "Alt+Shift+N".action = spawn "dms" "ipc" "call" "controls" "toggle";
      # "Alt+N".action = spawn "dms" "ipc" "call" "controls" "toggle";
      # "Mod+N".action = spawn "dms" "ipc" "call" "controls" "toggle";
     
      # Power Menu
      # "Alt+Shift+E".action = spawn "dms" "ipc" "call" "powermenu" "toggle";
    };
  
    # Startup programs
    spawn-at-startup = [
      { command = [ "dbus-update-activation-environment" "--systemd" "WAYLAND_DISPLAY" "XDG_CURRENT_DESKTOP" ]; }
      { command = [ "systemctl" "--user" "start" "niri.service" ]; }
      #{ command = [ "${pkgs.dms}/bin/dms" "run" ]; }
      { command = [ "${pkgs.waybar}/bin/waybar" ]; }
      { command = [ "${pkgs.kitty}/bin/kitty" "--title=Terminal" ]; }
      { command = [ "${pkgs.hypridle}/bin/hypridle" ]; }
      { command = [ "wl-paste --watch cliphist store" ]; }
      { command = [ "google-chrome-stable" ]; }
    ];
  };

  #home.file.".config/niri/dms".source = "${inputs.dms.packages.${pkgs.system}.default}/share/dms/niri";

  xdg.portal = {
    enable = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-gnome
      pkgs.xdg-desktop-portal-gtk
    ];
    config = {
      common = {
        default = [ "gnome" "gtk" ];
        "org.freedesktop.impl.portal.Access" = [ "gtk" ];
        "org.freedesktop.impl.portal.Notification" = [ "gtk" ];
        "org.freedesktop.impl.portal.Secret" = [ "gnome-keyring" ];
      };
    };
  };
}
