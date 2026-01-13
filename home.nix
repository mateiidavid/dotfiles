# Home manager:
# https://nix-community.github.io/home-manager/index.xhtml
# Allows us to manage user-level configuration, the main
# nixos flake is intended for user-level configuration.
# This includes:
# - programs, config files, env vars
# - arbitrary files
# notice how it has the same layout as a module, it is a module
# and will be built together with the profile when running
# `nixos-rebuild`
# TODO: need to pass in baan differently
{
  config,
  pkgs,
  ...
}: {
  home.username = "matei";
  home.homeDirectory = "/home/matei";
  # TODO: need an overlay for baan maybe
  imports = [
    ./pkgs/helix.nix
    ./pkgs/nvim.nix
    ./pkgs/baan.nix
    ./pkgs/desktop
    ./modules/shell.nix
    ./modules/shell-utils.nix
  ];

  # Enable custom modules
  control-tower.shell.enable = true;
  control-tower.shellUtils = {
    enable = true;
    starship = true;
    zellij = true;
    direnv = true;
  };

  # TODO: separate, "homegrown" nix file
  programs.baan = {
    enable = true;
    notesHomePath = "/home/matei/workspace/notes";
  };

  # Packages that should be installed to user profile
  # I assume these will come automatically from nixpkgs
  home.packages = with pkgs; [
    fastfetch
    claude-code

    rustup
    gcc

    # archives
    zip
    xz
    unzip

    # utils
    ripgrep
    jq # lol always need this
    eza # modern ls
    fzf # CLI fuzzy finder

    # must be done
    python3

    # unfree
    _1password-cli
    _1password-gui
    discord
    spotify

    # network tools
    nmap # network discovery & audit
    ldns # dig replacement
    socat # replacement for netcat

    # GNU
    tree
    gnused
    gnutar
    gawk
    gnupg # privacy guard

    # Misc
    glow # markdown preview in terminal
    btop # htop/nmon replacement
    iftop # netw monitoring

    # Sys monitoring
    strace
    lsof

    # Sys tools
    lm_sensors # for `sensors` command
    usbutils # lsusb
    sysstat

    # Nix stuff
    # provides a `nom` command that works just like `nix` with more
    # details log output
    nix-output-monitor

    # spotify
    # Serial
    screen
    minicom

    # D-Bus stuff
    d-spy

    man-pages
    man-pages-posix
    linux-manual

    # Nix
    nixd
    alejandra
  ];

  programs.git = {
    enable = true;
    userName = "comradeshr00m";
    userEmail = "typedfrog@proton.me";
    aliases = {
      st = "status";
      co = "checkout";
    };

    delta.enable = true;
    extraConfig = {
      init.defaultBranch = "main";
    };
  };

  programs.ghostty = {
    enable = true;
  };

  xdg.configFile."ghostty".source = config.lib.file.mkOutOfStoreSymlink ./ghostty;

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "24.11";

  xdg = {
    enable = true;
    # XDG_CONFIG_HOME
    configHome = "${config.home.homeDirectory}/.config";
    # XDG_DATA_HOME
    dataHome = "${config.home.homeDirectory}/.local/share";
    # XDG_CACHE_HOME
    cacheHome = "${config.home.homeDirectory}/.cache";
    # XDG_STATE_HOME
    stateHome = "${config.home.homeDirectory}/.local/state";
  };
  # Let home Manager install and manage itself.
  programs.home-manager.enable = true;
}
# link the configuration file in current directory to the specified location in home directory
# home.file.".config/i3/wallpaper.jpg".source = ./wallpaper.jpg;
# link all files in `./scripts` to `~/.config/i3/scripts`
# home.file.".config/i3/scripts" = {
#   source = ./scripts;
#   recursive = true;   # link recursively
#   executable = true;  # make all files executable
# };
# encode the file content in nix configuration file directly
# home.file.".xxx".text = ''
#     xxx
# '';
# set cursor size and dpi for 4k monitor
# xresources.properties = {
#    "Xcursor.size" = 16;
#    "Xft.dpi" = 172;
#  };

