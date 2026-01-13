{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.programs.neovim;
  localPath = "${config.home.homeDirectory}/workspace/dotfiles/nvim";
  drvPath = pkgs.stdenv.mkDerivation {
    name = "neovim-lua-config";
    src = ../nvim;
    installPhase = ''
      mkdir -p $out
      cp -r . $out/
    '';
  };
in {
  options.programs.neovim.autoConfigure = lib.mkEnableOption "when enabled builds the neovim config";
  config = {
    programs.neovim = {
      enable = true;

      plugins = with pkgs.vimPlugins; [
        (nvim-treesitter.withPlugins (p: [
          p.bash
          p.c
          p.json
          p.kdl
          p.lua
          p.markdown
          p.meson
          p.nix
          p.perl
          p.python
          p.rust
          p.terraform
          p.toml
          p.yaml
          p.zig
        ]))

        nvim-lspconfig
      ];
    };

    xdg.configFile."nvim".source =
      if cfg.autoConfigure
      then builtins.trace "using autoconfigured plugins from Nix store" drvPath
      else builtins.trace "using local path from ${localPath}" config.lib.file.mkOutOfStoreSymlink localPath;
    # other configurations
  };
}
