{
  config,
  osConfig,
  lib,
  pkgs,
  ...
}: let
  desktopCfg = osConfig.desktop;
  enable = desktopCfg.enable == "niri" || desktopCfg.enable == "multi";
in {
  imports = [];

  config = lib.mkIf enable {
    # Wallpaper & lockscreen into the Nix store
    home.file.".local/share/wallpapers/wallpaper.jpg".source = ../../share/images/wallhaven-lmzrx2.png;
    home.file.".local/share/wallpapers/lockscreen.jpg".source = ../../share/images/wallhaven-lmzrx2.png;
    home.file.".local/share/wallpapers/user-photo.jpg".source = ../../share/images/keroro.jpg;

    # Niri compositor
    xdg.configFile."niri/config.kdl".source = ./niri.kdl;

    # Power menu script
    xdg.configFile."niri/power-menu.sh" = {
      source = ./power-menu.sh;
      executable = true;
    };

    # Waybar
    xdg.configFile."waybar/config.jsonc".source = ./waybar/config.jsonc;
    xdg.configFile."waybar/style.css".source = ./waybar/style.css;
    xdg.configFile."waybar/weather.sh" = {
      source = ./waybar/weather.sh;
      executable = true;
    };
    xdg.configFile."waybar/weather-set-city.sh" = {
      source = ./waybar/weather-set-city.sh;
      executable = true;
    };
    xdg.configFile."waybar/battery.sh" = {
      source = ./waybar/battery.sh;
      executable = true;
    };
    xdg.configFile."waybar/weather-city".text = "London";

    # Fuzzel launcher
    xdg.configFile."fuzzel/fuzzel.ini".source = ./fuzzel.ini;

    # Mako notifications
    xdg.configFile."mako/config".source = ./mako.conf;

    # hyprlock
    xdg.configFile."hypr/hyprlock.conf".source = ./hyprlock.conf;
  };
}
