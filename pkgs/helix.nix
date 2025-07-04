{ pkgs, ... }: {
  programs.helix = {
    enable = true;
    settings = {
      theme = "rose_pine_moon";
      #theme = "catppuccin_macchiato";
      #theme = "everforest_dark";
      editor = {
        line-number = "relative";
        cursor-shape = {
          insert = "bar";
          normal = "block";
        };
        inline-diagnostics = {
          # 'disable'
          cursor-line = "hint";
          other-lines = "disable";
        };
        # handle externally changed files
        file-picker.hidden = true;
        soft-wrap.enable = true;
        auto-pairs = true;
        bufferline = "always";
        lsp = { display-messages = true; };
        statusline = {
          left = [ "mode" "spacer" "spacer" "file-name" ];
          center = [ "spinner" "spacer" "version-control" "diagnostics" ];
          right = [
            "read-only-indicator"
            "file-type"
            "position-percentage"
            "position"
          ];
          mode.normal = "NORMAL";
          mode.insert = "INSERT";
          mode.select = "SELECT";
        };

        color-modes = true;
        cursorline = true;
      };

      keys.normal = {
        "$" = "goto_line_end";
        "^" = "goto_line_start";
        "C-p" = "file_picker";
        "C-c" = "no_op";
        "g".q = ":reflow";
      };

      keys.insert = {
        "C-c" = "normal_mode";
        "C-space" = "completion";
      };

      keys.select = { "C-c" = "normal_mode"; };
    };

    languages.language = [
      {
        name = "nix";
        auto-format = true;
        formatter.command = "${pkgs.nixfmt-rfc-style}/bin/nixfmt";
      }

      {
        name = "rust";
        auto-format = true;
        formatter = {
          command = "rustfmt";
          args = [ "--edition" "2024" ];
        };
      }

      {
        name = "c";
        auto-format = true;
        formatter = {
          command = "clang-format";
          args = [ "--style=file" ];
        };
      }
      {
        name = "perl";
        auto-format = true;
        formatter = {
          command = "perltidy";
          args = [ "--standard-output" "--standard-error-output" "--quiet" ];
        };
      }
    ];
  };
}
