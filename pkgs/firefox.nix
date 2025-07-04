{ user }:
{ pkgs, lib, ... }:

let
  gwfox-theme = pkgs.stdenv.mkDerivation rec {
    name = "gwfox";
    version = "2.7.4";

    src = pkgs.fetchFromGitHub {
      owner = "akkva";
      repo = "${name}";
      tag = "${version}";
      sha256 = "sha256-GbF4tOvkMJyuOouUSLPMHTXTePm14H+hrwhDk68HX/0=";
    };

    installPhase = ''
      mkdir -p $out
      cp -r * $out/
    '';

  };
  # Preferences in Firefox for gwfox
  gwfoxPrefs = {
    # Enable userChrome.css support
    "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
    "svg.context-properties.content.enabled" = true;

    # Platform-specific settings
    "widget.windows.mica" = true; # Windows only - set conditionally if needed

    # Disable conflicting features
    "browser.urlbar.scotchBonnet.enableOverride" = false;
    "sidebar.animation.enabled" = false;
    "widget.macos.native-context-menus" = false; # macOS optional

    # Additional recommended settings for better experience
    "browser.tabs.inTitlebar" = 1;
    "browser.tabs.extraDragSpace" = false;

    "gwfox.plus" = true;
    "gwfox.atbc" = true;
  };

in {

  home-manager.users.${user} = { ... }: {
    home.file.".mozilla/firefox/gwfox/chrome/resources" = {
      source = "${gwfox-theme}/chrome/resources";
      recursive = true;
    };
    programs.firefox = {
      enable = true;

      # create a profile with gwfox
      profiles.gwfox = {
        id = 0;
        isDefault = true;

        settings = gwfoxPrefs;

        userChrome = builtins.readFile "${gwfox-theme}/chrome/userChrome.css";
        userContent = builtins.readFile "${gwfox-theme}/chrome/userContent.css";
        extraConfig = builtins.readFile "${gwfox-theme}/user.js";
      };
    };
  };
}
