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
  ];

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

  home.sessionVariables = {
    TERMINAL = "ghostty";
    FZF_DEFAULT_COMMAND = "rg --files --hidden";
  };

  home.sessionPath = [
    "$HOME/.local/bin"
    "$HOME/.cargo/bin"
  ];

  home.shellAliases = {
    g = "git";
    gst = "git status";
    la = "eza -la --icons --colour-scale";
    ll = "eza -abghHli --icons";
    ls = "eza --icons";
    tree = "eza --tree";
    nb = "nix build";
    nd = "nix develop";
    nf = "nix flake";
    nflake = "command nix flake";
    ns = "nix shell";
    # TODO(@mdavid): should receive the path from args
    nswitch = "nixos-rebuild switch --flake $HOME/workspace/dotfiles --use-remote-sudo && exec $SHELL -l";
    pbcopy = "wl-copy";
    pbpaste = "wl-paste";
  };

  programs.starship = {
    enable = true;
    settings = {
      format = "$username$directory$git_branch$git_state$git_status$cmd_duration$line_break$jobs$character";
      directory = {
        truncation_length = 1;
        truncation_symbol = "";
        fish_style_pwd_dir_length = 1;
        style = "blue";
      };
      username = {
        format = "[$user ]($style)";
        style_user = "bold #eb6f92";
      };
      character = {
        success_symbol = "[:;](bold green)";
        error_symbol = "[:;](bold red)";
      };
      jobs = {
        symbol = "✦ ";
        number_threshold = 2;
        symbol_threshold = 1;
      };
      git_branch = {
        format = "[$branch]($style)";
        symbol = " ";
        style = "bright-black";
      };
      cmd_duration = {
        format = "[$duration]($style) ";
        style = "yellow";
      };

      git_status = {
        style = "cyan";
        conflicted = "";
        untracked = "";
        modified = "";
        staged = "";
        renamed = "";
        deleted = "";
        stashed = "≡";
        format = "[([*$conflicted$untracked$modified](218) $ahead_behind$stashed)]($style) ";
        ahead = "⇡\${count}";
        behind = "⇣\${count}";
        diverged = "⇕⇡\${ahead_count}⇣\${behind_count}";
      };
      git_state = {
        format = "([$state( $progress_current/$progress_total)]($style)) ";
        style = "bright-black";
      };
    };
  };
  programs.ghostty = {
    enable = true;
  };

  xdg.configFile."ghostty".source = config.lib.file.mkOutOfStoreSymlink ./ghostty;

  # https://search.nixos.org/options
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    initContent = ''
       bindkey '^R' history-incremental-search-backward
       bindkey '^[[1;5C' forward-word
       bindkey '^[[1;5D' backward-word

       # helper function that returns 0 if `nom` should be used for
       # command output.
       # supported: `nix build|develop|shell|run` and `nix flake check|build`
       _use_nom() {
           case "$1" in
               build|develop|shell|run) return 0 ;;
               flake)
                   case "$2" in
                       check|build) return 0 ;;
                       *) return 1 ;;
                   esac
                   ;;
               *) return 1 ;;
           esac
       }
       # pipe output through `nom` if available on $PATH
       nix() {
           if command -v nom >/dev/null 2>&1 && _use_nom "$@"; then
               command nix "$@" |& nom
           else
               command nix "$@"
           fi
      }
    '';
    # initExtra = builtins.readFile .zshrc
  };

  programs.zellij = {
    enable = true;
    #enableZshIntegration = true;
    settings = {
      # theme = "catppuccin-mocha";
      theme = "tokyo-night-storm";
      mouse_mode = true;
    };
  };

  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
  };

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

