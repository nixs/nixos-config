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
  
    # Example Keybindings
    binds = with config.lib.niri.actions; {
      # "Alt+Shift+Return".action = spawn "gnome-terminal" "--app-id" "terminal.niri";
      # "Alt+Shift+T".action = spawn "gnome-terminal" "--app-id" "terminal.niri";
      # "Mod+Return".action = spawn "gnome-terminal" "--app-id" "terminal.niri";
      # Replace with your preferred keys
      "Mod+Shift+Slash".action = { show-hotkey-overlay = { }; };
      "Alt+Shift+Slash".action = { show-hotkey-overlay = { }; };
      "Mod+Shift+E".action = { quit = { }; };
      "Alt+Shift+E".action = { quit = { }; };
    
      "Alt+Shift+Return".action = spawn "kitty";
      "Alt+Shift+T".action = spawn "kitty";
      "Mod+Return".action = spawn "kitty";
      "Mod+D".action = spawn "fuzzel";
      "Alt+D".action = spawn "fuzzel";
      "Mod+F".action = spawn "${pkgs.rofi}/bin/rofi -show";
      "Alt+F".action = spawn "${pkgs.rofi}/bin/rofi -show";
      "Mod+Q".action = close-window;
      "Alt+Shift+Q".action = close-window;
      
      # Scrolling / Navigation
      "Alt+H".action = focus-column-left;
      "Alt+L".action = focus-column-right;
      "Alt+K".action = focus-window-or-workspace-up;
      "Alt+J".action = focus-window-or-workspace-down;
      "Alt+Shift+Left".action = focus-column-left;
      "Alt+Shift+Right".action = focus-column-right;
      "Alt+Shift+Up".action = focus-window-or-workspace-up;
      "Alt+Shift+Down".action = focus-window-or-workspace-down;

      # Moving Windows
      "Alt+Shift+Ctrl+Left".action = move-column-left;
      "Alt+Shift+Ctrl+Right".action = move-column-right;

      # Layout Controls
      "Alt+Shift+R".action = switch-preset-column-width;
      "Alt+Shift+F".action = maximize-column;
      "Alt+Shift+Space".action = toggle-window-floating;

      "Alt+Comma".action = consume-window-into-column;
      "Alt+Period".action = expel-window-from-column;
     
      # Screenshot (requires grim/slurp)
      # "Print".action = screenshot;
  
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
      { command = [ "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1" ]; }
      { command = [ "${pkgs.waybar}/bin/waybar" ]; }
      #{ command = [ "${pkgs.dms}/bin/dms" "run" ]; }
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
      };
    };
  };
}
