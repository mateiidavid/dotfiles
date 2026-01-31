{ config
, lib
, ...
}:
with lib; let
  cfg = config.control-tower.shell;
in
{
  options.control-tower.shell = {
    enable = mkEnableOption "custom shell configuration (control tower)";

    aliases = {
      enable = mkOption {
        type = types.bool;
        default = true;
        description = "Enable default shell aliases";
      };

      extraAliases = mkOption {
        type = types.attrs;
        default = { };
        description = "Additional aliases to merge with defaults";
        example = { myalias = "echo hello"; };
      };
    };

    sessionVariables = {
      enable = mkOption {
        type = types.bool;
        default = true;
        description = "Enable default session variables";
      };

      extraSessionVariables = mkOption {
        type = types.attrs;
        default = { };
        description = "Additional session variables to merge with defaults";
        example = { EDITOR = "vim"; };
      };
    };

    sessionPath = {
      enable = mkOption {
        type = types.bool;
        default = true;
        description = "Enable default session paths";
      };

      extraPaths = mkOption {
        type = types.listOf types.str;
        default = [ ];
        description = "Additional paths to add to session PATH";
        example = [ "$HOME/.local/scripts" ];
      };
    };

    zsh = {
      enable = mkOption {
        type = types.bool;
        default = true;
        description = "Enable ZSH with custom configuration";
      };


      enableNixWrapper = mkOption {
        type = types.bool;
        default = true;
        description = "Enable nix() wrapper function that pipes output through nom";
      };

      extraInitContent = mkOption {
        type = types.lines;
        default = "";
        description = "Additional ZSH init content";
        example = ''
          # Custom function
          hello() { echo "Hello, $1!"; }
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    # Shell aliases
    home.shellAliases = mkIf cfg.aliases.enable (mkMerge [
      {
        # Git shortcuts
        g = "git";
        gst = "git status";

        # eza (modern ls)
        # la = "eza -la --icons=auto --colour-scale";
        ll = "eza -abghHli --icons=auto";
        # ls = "eza --color=auto --icons=auto";
        tree = "eza --tree";

        # Nix shortcuts
        nb = "nix build";
        nd = "nix develop";
        nf = "nix flake";
        nflake = "command nix flake";
        ns = "nix shell";
        nswitch = "nixos-rebuild switch --flake $HOME/workspace/dotfiles --use-remote-sudo && exec $SHELL -l";

        # Clipboard (Wayland)
        pbcopy = "wl-copy";
        pbpaste = "wl-paste";
      }
      cfg.aliases.extraAliases
    ]);

    # Session variables
    home.sessionVariables = mkIf cfg.sessionVariables.enable (mkMerge [
      {
        TERMINAL = "ghostty";
        FZF_DEFAULT_COMMAND = "rg --files --hidden";
      }
      cfg.sessionVariables.extraSessionVariables
    ]);

    # Session paths
    home.sessionPath = mkIf cfg.sessionPath.enable (
      [
        "$HOME/.local/bin"
        "$HOME/.cargo/bin"
      ]
      ++ cfg.sessionPath.extraPaths
    );

    # ZSH configuration
    programs.zsh = mkIf cfg.zsh.enable {
      enable = true;
      enableCompletion = true;

      initContent = mkMerge [
        ''
          # Allows ctrl+r to work and allows ctrl + left/right
          bindkey '^R' history-incremental-search-backward
          bindkey '^[[1;5C' forward-word
          bindkey '^[[1;5D' backward-word
        ''

        (mkIf cfg.zsh.enableNixWrapper ''
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
        '')

        cfg.zsh.extraInitContent
      ];
    };
  };
}
