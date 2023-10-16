{
  pkgs,
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.local;
in {
  options.local.fuzzel.enable = mkOption {
    type = types.bool;
    default = cfg.hyprland.enable;
  };
  config = mkIf cfg.fuzzel.enable {
    home.packages = with pkgs; [fuzzel numix-icon-theme];
    xdg.configFile."fuzzel/fuzzel.ini".source = ./config;
  };
}
