{
  user,
  gwFoxEnabled ? false,
}: {
  pkgs,
  lib,
  ...
}: let
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
  basePrefs = {
    # Enable userChrome.css support
    "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
    "svg.context-properties.content.enabled" = true;

    # General UI improvements
    # Additional recommended settings for better experience
    "browser.tabs.inTitlebar" = 1;
    "browser.tabs.extraDragSpace" = false;

    # Disable conflicting features
    "browser.urlbar.scotchBonnet.enableOverride" = false;
  };
  # Preferences in Firefox for gwfox
  gwfoxPrefs =
    basePrefs
    // {
      # Platform-specific settings
      "widget.windows.mica" = true; # Windows only - set conditionally if needed
      "widget.macos.native-context-menus" = false; # macOS optional
      "sidebar.animation.enabled" = false;

      "gwfox.plus" = true;
      "gwfox.atbc" = true;
    };
  # Preferences for default firefox + treestyle tabs on the lefthand side.
  verticalTabsPrefs =
    basePrefs
    // {
      # Native firefox sidebar
      "sidebar.revamp" = true;
      "sidebar.verticalTabs" = true;

      # Tree Style Tab works better with these settings
      "browser.tabs.drawInTitlebar" = true;

      # Enable native Firefox tab groups (works well with Tree Style Tab)
      "browser.tabs.groups.enabled" = true;

      # Optional: Enable AI-powered smart tab grouping suggestions
      "browser.tabs.groups.smart.enabled" = true;
      "browser.tabs.groups.smart.userEnabled" = true;
    };
  gwFoxSettings = {
    settings = gwfoxPrefs;
    userChrome = builtins.readFile "${gwfox-theme}/chrome/userChrome.css";
    userContent = builtins.readFile "${gwfox-theme}/chrome/userContent.css";
    extraConfig = builtins.readFile "${gwfox-theme}/user.js";
  };
  verticalTabSettings = {
    settings = verticalTabsPrefs;
  };
in {
  home-manager.users.${user} = {...}: {
    home.file = lib.mkIf gwFoxEnabled {
      ".mozilla/firefox/gwfox/chrome/resources" = {
        source = "${gwfox-theme}/chrome/resources";
        recursive = true;
      };
    };
    programs.firefox = {
      enable = true;

      # create a profile with gwfox
      profiles.gwfox = lib.mkMerge [
        {
          id = 0;
          isDefault = true;
        }
        (lib.mkIf gwFoxEnabled gwFoxSettings)
        (lib.mkIf (!gwFoxEnabled) verticalTabSettings)
      ];
    };
  };
}
