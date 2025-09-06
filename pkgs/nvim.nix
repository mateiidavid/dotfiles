{
  config,
  pkgs,
  ...
}: let
  nvimPath = "${config.home.homeDirectory}/workspace/dotfiles/nvim";
in {
  programs.neovim = {
    enable = true;

    plugins = with pkgs.vimPlugins; [
      (nvim-treesitter.withPlugins (p: [
        p.bash
        p.c
        p.json
        p.lua
        p.markdown
        p.nix
        p.perl
        p.python
        p.rust
        p.yaml
      ]))

      nvim-lspconfig
    ];
  };

  xdg.configFile."nvim".source = config.lib.file.mkOutOfStoreSymlink nvimPath;
  # other configurations
}
