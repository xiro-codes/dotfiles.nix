{
  pkgs,
  config,
  lib,
  ...
}: let
  inherit (lib) mkOption mkIf types;
  cfg = config.local;
in {
  imports = [];
  options.local.lf = {
    enable = mkOption {
      type = types.bool;
      default = cfg.enable;
    };
  };
  config = mkIf (cfg.lf.enable) {
    xdg.configFile."lf/icons".source = ./icons;
    programs.lf = {
      enable = true;
      commands = {
        editor-open = ''$$EDITOR $f'';
      };
      settings = {
        preview = true;
        drawbox = true;
        icons = true;
        ignorecase = true;
      };
      keybindings = {
        ed = "editor-open";
      };
    };
  };
}
