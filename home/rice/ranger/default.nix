{pkgs, config, lib, ...}: let
  inherit (lib) mkOption mkIf types;
  cfg = config.rice;
in {
  imports = [];
  options.rice.ranger = {
    enable = mkOption {
      type = types.bool;
      default = cfg.enable;
    };
  };
  config = mkIf (cfg.ranger.enable) {
    home.packages = [ pkgs.ranger ];
    xdg.configFile = {
      "ranger/rifle.conf".source = ./rifle.conf;
      "ranger/rc.conf".source  = ./rc.conf;
    };
    rice.fileManager = "${pkgs.ranger}/bin/ranger";
  };
}
