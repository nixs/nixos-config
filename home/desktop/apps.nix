{ config, lib, pkgs, ... }:
let
  cfg = config.programs.webApps;
  configPath = config.xdg.configHome;

  appIdRegex = url: "^chrome-${lib.strings.head (lib.strings.splitString "/" (lib.strings.removePrefix "https://" url))}.*";


  sortedApps = lib.sort (a: b: a.priority < b.priority) 
    (lib.mapAttrsToList (id: app: app // { inherit id; }) cfg.apps);
  orderedModuleIds = map (app: "custom/${app.id}") sortedApps;
in {
  options.programs.webApps.apps = lib.mkOption {
    type = lib.types.attrsOf (lib.types.submodule {
      options = {
        name = lib.mkOption { type = lib.types.str; };
        icon = lib.mkOption { type = lib.types.str; default = "🌐"; };
        url = lib.mkOption { type = lib.types.str; };
        desktopIcon = lib.mkOption { type = lib.types.str; default = "web-browser"; };
        text = lib.mkOption { type = lib.types.nullOr lib.types.lines; default = null; };
        source = lib.mkOption { type = lib.types.nullOr lib.types.path; default = null; };
        priority = lib.mkOption { type = lib.types.int; default = 1000; };
      };
    });
    default = {};
    description = "A set of web apps to generate Niri focus/open scripts for.";
  };

  config = lib.mkIf (cfg != {}) {
    home.packages = with pkgs; [
      gtk3
      jq
      (pkgs.writeScriptBin "niri-focus-or-open"
        (builtins.readFile ./scripts/niri-focus-or-open.sh))
    ];

    # Add optional script file
    xdg.configFile = lib.listToAttrs (lib.flatten (lib.mapAttrsToList (id: app:
      if (app.text != null || app.source != null) then [{
        name = "web-apps/scripts/${id}.sh";
        value = {
          executable = true;
          text = app.text;
          source = app.source;
        };
      }] else []
    ) cfg.apps));

    # Add desktop entries
    xdg.desktopEntries = lib.mapAttrs (id: app: {
      name = app.name;
      exec = if (app.text != null || app.source != null)
        then "${configPath}/web-apps/scripts/${id}.sh"
        else ''niri-focus-or-open "${appIdRegex app.url}" "google-chrome --app=${app.url}"'';
      icon = app.desktopIcon;
      categories = [ "Network" "WebBrowser" ];
    }) cfg.apps;

    # Add waybar modules (must still be added to waybar config)
    programs.waybar.settings.mainBar = {
      "group/web-apps" = {
        modules = orderedModuleIds;
        orientation = "horizontal";
      };
    } // (lib.mapAttrs' (id: app: lib.nameValuePair "custom/${id}" {
      format = app.icon;
      tooltip = app.name;
      on-click = "gtk-launch ${id}";
    }) cfg.apps);

    # Default apps
    programs.webApps.apps = {
      gmail = {
        name = "Gmail";
        icon = " 󰇮 ";
        url = "https://mail.google.com";
        desktopIcon = "mail-message-new";
        priority = 10;
      };
      calendar = {
        name = "Google Calendar";
        icon = " 󰃭 ";
        url = "https://calendar.google.com";
        desktopIcon = "office-calendar";
        priority = 20;
      };
    };
  };
}
