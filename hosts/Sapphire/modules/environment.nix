{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf mkOption types mkEnableOption;
  cfg = config.local;
in {
  imports = [
  ];
  options.local.environment = {
    enable = mkOption {
      type = types.bool;
      default = cfg.enable;
    };
  };
  config = mkIf cfg.environment.enable {
    environment.variables = {
      CLUTTER_BACKEND = "wayland";
      GDK_BACKEND = "x11";
      GDK_DPI_SCALE = "1";
      MOZ_ENABLE_WAYLAND = "1";
      QT_QPA_PLATFORM = "wayland";
      QT_QPA_PLATFORMTHEME = "qt5ct";
      QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
      WLR_NO_HARDWARE_CURSORS = "1";
      _JAVA_AWT_WM_NONREPARENTING = "1";
      #_JAVA_OPTIONS = "-Dawt.useSystemAAFontSettings=on";
    };
    environment.systemPackages = cfg.packages;
  };
}
