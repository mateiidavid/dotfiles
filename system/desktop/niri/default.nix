{
  config,
  lib,
  ...
}: let
  cfg = config.desktop;
  enabled = cfg.enabled == "niri" || cfg.enabled == "multi";
  inherit (lib) mkOption mkIf types;
in {
  options.desktop.enable = mkOption {
    type = with types; nullOr (enum ["gnome"]);
  };

  config = mkIf enabled {
    programs.niri.enable = true;

    # For now, re-use GNOME's DM
    services.xserver.displayManager.gdm = {
      enable = true;
      wayland = true;
    };

    # == GNOME SERVICES ==
    services.gnome.gnome-keyring.enable = true;
  };
}
