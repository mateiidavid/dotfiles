{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.desktop;
  inherit (lib) mkIf mkOption types;
in {
  imports = [
    # import niri and gnome
    ./gnome.nix
    ./niri
  ];

  options.desktop = {
    enable = mkOption {
      type = with types; nullOr (enum ["multi"]);
      default = null;
      description = "Which desktop configuration to use";
      example = "niri";
    };
  };

  config = mkIf (cfg.enable != null) {
    # Enable the X11 windowing system.
    services.xserver = {
      enable = true;
      # Configure keymap in X11
      xkb.layout = "us";
    };

    # Enable touchpad support (enabled default in most desktopManager).
    services.libinput.enable = true;

    # Enable sound.
    # hardware.pulseaudio.enable = true;
    # OR
    services.pipewire = {
      enable = true;
      pulse.enable = true;
    };

    environment.systemPackages = with pkgs; [
      wl-clipboard
    ];
  };
}
