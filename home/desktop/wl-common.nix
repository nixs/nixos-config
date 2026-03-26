{ pkgs, ... }:
{
  imports = [
  ];

  services = {
    cliphist = {
      enable = true;
      package = pkgs.cliphist;
    };

    gnome-keyring.enable = true;

    wlsunset = {
      enable = true;
      latitude = "37.39";
      longitude = "-122.08";
    };
  };

  systemd.user.services.polkit-gnome-authentication-agent-1 = {
    Unit = {
      Description = "polkit-gnome-authentication-agent-1";
      After = [ "graphical-session.target" ];
    };
    Install.WantedBy = [ "graphical-session.target" ];
    Service = {
      Type = "simple";
      ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
      Restart = "on-failure";
      RestartSec = 1;
      TimeoutStopSec = 10;
    };
  };

  home.packages = with pkgs; [
    brightnessctl
    grim
    playerctl
    polkit_gnome
    slurp
    swappy
    wl-clipboard
    wdisplays
  ];

  home.file.".config/swappy/config".text = ''
    [Default]
    save_dir=$HOME/Pictures/Screenshots
    save_filename_format=Screenshot-%Y%m%d-%H%M%S.png
    early_exit=true
  '';

  home.sessionVariables = {
    _JAVA_AWT_WM_NONREPARENTING = "1";
    CLUTTER_BACKEND = "wayland";
    GDK_BACKEND = "wayland";
    MOZ_ENABLE_WAYLAND = "1";
    QT_QPA_PLATFORM = "wayland";
    # QT_QPA_PLATFORMTHEME = "qt5ct";
    QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
    SDL_VIDEODRIVER = "wayland";
    XDG_SESSION_TYPE = "wayland";
    NIXOS_OZONE_WL = "1";
    WAYLAND_DISPLAY = "wayland-1";

    QT_PLUGIN_PATH = "${pkgs.qt6.qtwayland}/lib/qt-6/plugins";
    NIXPKGS_QT6_QML_IMPORT_PATH = "${pkgs.qt6.qtbase}/lib/qt-6/qml";
  };
}
