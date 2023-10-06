{
  pkgs,
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.rice;
in {
  options.rice.fuzzel.enable = mkOption {
    type = types.bool;
    default = cfg.hyprland.enable;
  };
  config = mkIf cfg.fuzzel.enable {
    home.packages = with pkgs; [fuzzel];
    xdg.configFile."fuzzel/fuzzel.ini".source = ./config;
  };
}
