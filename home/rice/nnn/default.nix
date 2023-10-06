{pkgs, config, lib, ...}: let
  inherit (lib) mkOption mkIf types;
  cfg = config.rice;
in {
  imports = [];
  options.rice.nnn = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };
  config = mkIf (cfg.nnn.enable) {
    programs.nnn.enable = true;
    rice.fileManager = "${config.programs.nnn.finalPackage}/bin/nnn";
  };
}
