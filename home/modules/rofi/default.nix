{
  pkgs,
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.local;
in {
  options.local.rofi.enable = mkOption {
    type = types.bool;
    default = cfg.hyprland.enable;
  };
  config = mkIf cfg.rofi.enable {
    home.packages = with pkgs; [];
    programs.rofi = {
      enable = true;
      package = pkgs.rofi-wayland;
      theme = ./gruvbox-dark.rasi;
    };
  };
}
