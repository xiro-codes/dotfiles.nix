{
  pkgs,
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.rice;
in {
  options.rice.wofi.enable = mkOption {
    type = types.bool;
    default = cfg.hyprland.enable;
  };
  config = mkIf cfg.wofi.enable {
    home.packages = with pkgs; [wofi];
    xdg.configFile."wofi/config".source = ./config;
    xdg.configFile."wofi/style.css".source = ./style.css;
  };
}
