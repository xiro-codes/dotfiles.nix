{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.local;
in {
  options.local.mako.enable = mkOption {
    type = types.bool;
    default = cfg.hyprland.enable;
  };
  config = mkIf (cfg.mako.enable) {
    services.mako = {
      enable = true;
      anchor = "bottom-center";
      backgroundColor = "#24283b";
      textColor = "#c0caf5";
      width = 350;
      margin = "0,20,20";
      padding = "10";
      borderSize = 2;
      borderColor = "#414868";
      borderRadius = 5;
      defaultTimeout = 10000;
      groupBy = "summary";
    };
  };
}
