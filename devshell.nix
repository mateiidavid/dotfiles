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
    echo ""
    echo ""

    blue "(◡ ω ◡)"
    blue "  uwu  "
  '';
}
