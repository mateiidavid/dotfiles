{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.desktop;
  enabled = cfg.enable == "niri" || cfg.enable == "multi";
  inherit (lib) mkOption mkIf types;
in {
  options.desktop.enable = mkOption {
    type = with types; nullOr (enum ["niri"]);
  };

  config = mkIf enabled {
    programs.niri = {
      enable = true;
      package = pkgs.niri-stable;
    };

    # For now, re-use GNOME's DM
    services.xserver.displayManager.gdm = {
      enable = true;
      wayland = true;
    };

    # == GNOME SERVICES ==
    services.gnome.gnome-keyring.enable = true;

    # == NIRI DESKTOP UTILITIES ==
    environment.systemPackages = with pkgs; [
      # Bar
      waybar

      # App launcher
      fuzzel

      # Notifications
      mako

      # Lock screen & idle
      hyprlock
      swayidle

      # Wallpaper
      swaybg

      # Media / brightness / audio control
      playerctl
      brightnessctl
      pamixer

      # Network GUI
      networkmanagerapplet

      # Bluetooth
      bluetuith

      # Weather widget
      wttrbar

      # Monitor configuration GUI
      wdisplays

      # Logitech mouse configuration
      logiops
    ];

    # Bluetooth service
    hardware.bluetooth.enable = true;

    # Allow hyprlock to authenticate
    security.pam.services.hyprlock = {};

    # == logiops (logid) — MX Master 3 gesture button driver ==
    # Maps thumb gesture button swipe directions to keypresses for niri.
    systemd.services.logid = {
      description = "Logitech Configuration Daemon (logiops)";
      wantedBy = ["multi-user.target"];
      after = ["multi-user.target"];
      serviceConfig = {
        ExecStart = "${pkgs.logiops}/bin/logid -c /etc/logid.cfg";
        Restart = "on-failure";
      };
    };

    environment.etc."logid.cfg".source = ../../../pkgs/desktop/logid.cfg;
  };
}
