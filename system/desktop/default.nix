{
  config,
  lib,
  ...
}: let
  cfg = config.desktop;
  inherit (lib) mkIf mkOption types;
in {
  imports = [
    # import niri and gnome
  ];

  options.desktop = {
    enable = mkOption {
      type = with types; nullOr (enum []);
      default = null;
      description = "Which desktop configuration to use";
      example = "niri";
    };
  };

  config =
    mkIf (cfg.enable != null) {
    };
}
