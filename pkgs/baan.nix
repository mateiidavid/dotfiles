{
  pkgs,
  config,
  lib,
  ...
}:
let
  cfg = config.programs.baan;
in
{
  options.programs.baan = {
    enable = lib.mkEnableOption "baan CLI program";

    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.baan;
      description = "The baan pkg to use";
    };

    notesHomePath = lib.mkOption {
      type = lib.types.path;
      description = "Directory to store notes";
    };
  };
  config = lib.mkIf cfg.enable {
    home.sessionVariables = {
      BAAN_HOME_DIR = "${cfg.notesHomePath}";
    };
    home.packages = [ cfg.package ];
  };
}
