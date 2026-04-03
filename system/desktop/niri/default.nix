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
    ];

    # Bluetooth service
    hardware.bluetooth.enable = true;

    # Allow hyprlock to authenticate
    security.pam.services.hyprlock = {};
  };
}
