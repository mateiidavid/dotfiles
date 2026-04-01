{ config
, lib
, ...
}:
with lib; let
  cfg = config.control-tower.shellUtils;
in
{
  options.control-tower.shellUtils = {
    enable = mkEnableOption "custom shell utilities (starship, zellij, direnv)";

    starship = mkEnableOption "Starship prompt with custom configuration";

    zellij = mkEnableOption "Zellij terminal multiplexer";

    direnv = mkEnableOption "direnv with nix-direnv integration";
  };

  config = mkIf cfg.enable {
    # Starship prompt
    programs.starship = mkIf cfg.starship {
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
          symbol = " ";
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

    # Zellij terminal multiplexer
    programs.zellij = mkIf cfg.zellij {
      enable = true;
      settings = {
        theme = "vesper";
        mouse_mode = true;
      };
      extraConfig = ''
        keybinds {
            normal clear-defaults=true {
                bind "Alt p" { SwitchToMode "Pane"; }
                bind "Alt t" { SwitchToMode "Tab"; }
                bind "Alt n" { SwitchToMode "Resize"; }
                bind "Alt s" { SwitchToMode "Scroll"; }
                bind "Alt o" { SwitchToMode "Session"; }
                bind "Alt h" { SwitchToMode "Move"; }
                bind "Alt g" { SwitchToMode "Locked"; }
                bind "Alt q" { Quit; }
                bind "Alt Left" { MoveFocusOrTab "Left"; }
                bind "Alt Right" { MoveFocusOrTab "Right"; }
                bind "Alt Down" { MoveFocus "Down"; }
                bind "Alt Up" { MoveFocus "Up"; }
                bind "Alt =" "Alt +" { Resize "Increase"; }
                bind "Alt -" { Resize "Decrease"; }
                bind "Alt f" { ToggleFocusFullscreen; }
                bind "Alt z" { TogglePaneFrames; }
                bind "Alt c" { NewPane; }
                bind "Alt x" { CloseFocus; }
                bind "Alt w" { ToggleFloatingPanes; }
                bind "Alt e" { TogglePaneEmbedOrFloating; }
            }
            locked {
                bind "Alt g" { SwitchToMode "Normal"; }
            }
            pane {
                bind "Alt p" { SwitchToMode "Normal"; }
                bind "d" { NewPane "Down"; SwitchToMode "Normal"; }
            }
            tab {
                bind "Alt t" { SwitchToMode "Normal"; }
            }
            resize {
                bind "Alt n" { SwitchToMode "Normal"; }
            }
            scroll {
                bind "Alt s" { SwitchToMode "Normal"; }
            }
            session {
                bind "Alt o" { SwitchToMode "Normal"; }
            }
            move {
                bind "Alt h" { SwitchToMode "Normal"; }
            }
            search {
                bind "Alt s" { SwitchToMode "Normal"; }
            }
        }
      '';
    };

    # Direnv for automatic dev environments
    programs.direnv = mkIf cfg.direnv {
      enable = true;
      enableZshIntegration = true;
      nix-direnv.enable = true;
    };
  };
}
