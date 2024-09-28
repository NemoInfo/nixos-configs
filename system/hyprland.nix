{ inputs, pkgs, config, ... }:
let
  conf = pkgs.writeText "config" ''
    exec-once = swww init 
    exec-once = swww img ${~/Pictures/wallpaper.jpg}
    misc {
      disable_hyprland_logo = true;
      disable_splash_logo = true;
      force_default_wallpaper = 0;
    }
    input {
      kb_layout = ${config.services.xserver.xkb.layout}
    }
  '';
in {
  services.xserver.displayManager.startx.enable = true;
  programs.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.system}.hyprland;
    xwayland.enable = true;
  };

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs;
      [ xdg-desktop-portal-gtk ]; # Maybe change to hyprland
  };

  security = {
    polkit.enable = true;
    pam.services.ags = { };
  };

  environment.systemPackages = with pkgs.gnome; [
    pkgs.swww
    pkgs.loupe
    adwaita-icon-theme
    pkgs.nautilus
    pkgs.baobab
    gnome-calendar
    gnome-boxes
    gnome-system-monitor
    gnome-control-center
    gnome-weather
    gnome-calculator
    gnome-clocks
    gnome-software
  ];

  systemd = {
    user.services.polkit-gnome-authentication-agent-1 = {
      description = "polkit-gnome-authentication-agent-1";
      wantedBy = [ "graphical-session.target" ];
      wants = [ "graphical-session.target" ];
      after = [ "graphical-session.target" ];
      serviceConfig = {
        Type = "simple";
        ExecStart =
          "${pkgs.polkit-gnome}/libexec/polkit-gnome-authentication-agent-1";
        Restart = "on-failure";
        RestartSec = 1;
        TimeoutStopSec = 10;
      };
    };
  };

  services = {
    gvfs.enable = true;
    devmon.enable = true;
    udisks2.enable = true;
    upower.enable = true;
    power-profiles-daemon.enable = true;
    accounts-daemon.enable = true;
    gnome = {
      evolution-data-server.enable = true;
      glib-networking.enable = true;
      gnome-keyring.enable = true;
      gnome-online-accounts = true;
    };
  };
}
