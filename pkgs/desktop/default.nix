{
  config,
  osConfig,
  lib,
  ...
}: let
  desktopCfg = osConfig.desktop;
  enable = desktopCfg.enable == "niri" || desktopCfg.enable == "multi";
in {
  imports = [];

  config = lib.mkIf enable {
    xdg.configFile."niri/config.kdl".source = ./niri.kdl;
  };
}
