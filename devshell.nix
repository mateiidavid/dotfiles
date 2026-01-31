{pkgs, ...}:
pkgs.mkShell {
  buildInputs = with pkgs; [
    fd
    git
    lua-language-server
    man-pages
    man-pages-posix
    stylua
    tree
    nixpkgs-fmt
  ];

  shellHook = ''
    red() { echo -e "\033[31m$1\033[0m "; }
    green() { echo -e "\033[32m$1\033[0m"; }
    yellow() { echo -e "\033[33m$1\033[0m"; }
    blue() { echo -e "\033[34m$1\033[0m"; }

    echo ""
    blue "Welcome to my dotfiles (◕‿◕)♡"
    echo ""
    green " Running \e[38;5;46m $(nix --version) "
    echo ""
    blue "  ======================= REPL BASICS ======================="
    yellow " :: nix repl -f '<nixpkgs>'                           # start repl with expr. from a file; start search"
    yellow "                                                      # for 'nixpkgs' listed in the env var NIX_PATH"
    yellow " :: :e, :edit <function>                              # open package or function in EDITOR, e.g. :e lib.mkDefault"
    echo ""
    blue " Example:"
    echo ""
    red " - \$ nix repl -f '<nixpkgs>'; :e lib.mkDefault          # open up \`lib.mkDefault\` src "
    red " - \$ nix repl -f '<nixpkgs>'; :e pkgs.fcitx5-rime       # open up a package src code  "
    red " - \$ nix-instantiate --eval -E \                        # test an overlay is working"
    red "        'with import <nixpkgs>' { overlays = [ \        # e.g. load up nixpkgs and"
    red "        (import ./your-overlay.nix) ]; }; \             # overlay with a diff version"
    red "        claude-code.version'                            # of claude-code"
    echo ""
    blue "  ======================= USEFUL CMDS ======================="
    yellow " :: nixos-rebuild switch build --show-trace \         # get more detailed error messages   "
    yellow "      --print-build-logs --verbose                    # when building Nix                  "
    yellow " :: nix profile history --profile \                   # get all historical versions of     "
    yellow "      /nix/var/nix/profiles/system                    # the profile                        "
    yellow " :: nix profile wipe-history --older-than 7d \        # delete all historical versions     "
    yellow "      --profile /nix/var/nix/profiles/system          # older than 7 days                  "
    yellow " :: sudo nix-collect-garbage --delete-old             # GC (n.b. profiles are gc roots)    "
    yellow "                                                      # delete home manager historical     "
    yellow "                                                      # data, per user, see nix/issues/8508"
    yellow " :: nix-store --gc --print-roots \                    # find out why a package is installed"
    yellow "    |rg -v '/proc/' | rg -Po '(?<= -> ).*' \          # and print out a dependency chain   "
    yellow "    |xargs -o nix-tree                                # /<package-name> and \`w\` to find dep"
    echo ""
    blue "  ======================= TESTING ======================="
    yellow " :: nix eval --impure --expr '                        # test a module: modules are functions"
    yellow "      let pkgs = import <nixpkgs> {};                 # that take {config,lib,pkgs,...} and"
    yellow "          lib = pkgs.lib;                             # return {options, config}. We need  "
    yellow "          module = import ./modules/shell.nix         # to provide inputs manually since   "
    yellow "            { inherit lib pkgs; config = {};          # modules can't be called directly.  "
    yellow "              config.control-tower.shell.enable=true;}; # Enable our module for testing    "
    yellow "      in module.config.home.shellAliases.ls'          # Access the computed config value   "
    yellow " :: nix eval --impure --expr '                        # test mkMerge: mkMerge just creates "
    yellow "      let pkgs = import <nixpkgs> {}; lib = pkgs.lib; # {_type=\"merge\";} marker. To see   "
    yellow "          result = lib.evalModules { modules = [{    # actual merge, use lib.evalModules  "
    yellow "            options.vars = lib.mkOption {             # (what NixOS/HM does). Define a     "
    yellow "              type = lib.types.attrs; default = {};   # minimal module with options+config."
    yellow "            };                                        # Later values in mkMerge override   "
    yellow "            config.vars = lib.mkMerge [               # earlier ones (rightmost wins).     "
    yellow "              { TERMINAL = \"ghostty\"; }               # This example will output:          "
    yellow "              { TERMINAL = \"alacritty\"; }             # { TERMINAL = \"alacritty\"; }        "
    yellow "            ];                                        #                                    "
    yellow "          }]; };                                      #                                    "
    yellow "      in result.config.vars'                          #                                    "
    yellow " :: nix-build -E '(import <nixpkgs> {}).callPackage \ # test a package: packages are funcs "
    yellow "      ./pkgs/baan.nix {}'                             # that take deps as args. callPackage"
    yellow "                                                      # auto-injects deps from nixpkgs     "
    yellow " :: nix-store -q --tree \$(nix-build -E \             # trace derivation dependencies: show"
    yellow "      'with import <nixpkgs> {}; firefox')            # full dependency tree for a package "
    yellow " :: nix show-derivation \$(nix-instantiate \          # show derivation inputs: displays   "
    yellow "      '<nixpkgs>' -A firefox)                         # all inputs/deps for a derivation   "
    echo ""
    echo ""
    echo ""

    blue "(◡ ω ◡)"
    blue "  uwu  "
  '';
}
