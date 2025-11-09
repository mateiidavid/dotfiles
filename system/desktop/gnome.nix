{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.desktop;
  enabled = cfg.enable == "gnome" || cfg.enable == "multi";
  inherit (lib) mkIf mkOption types;
in {
  options.desktop.enable = mkOption {
    type = with types; nullOr (enum ["gnome"]);
  };

  config = mkIf enabled {
    services.xserver = {
      desktopManager.gnome.enable = true;
      displayManager.gdm = {
        enable = true;
        wayland = true;
      };
    };
    environment.systemPackages = with pkgs; [
      gnomeExtensions.dash-to-dock
      gnomeExtensions.blur-my-shell
      gnomeExtensions.media-controls
      gnomeExtensions.appindicator
      gnomeExtensions.color-picker
      gnomeExtensions.rounded-window-corners-reborn
      gnomeExtensions.pop-shell
      gnome-tweaks
    ];
  };
}
