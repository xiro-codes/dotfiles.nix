{ pkgs
, config
, lib
, ...
}:
with lib; let
  inherit (pkgs) writeShellScriptBin;
  inherit (builtins) readFile;
  cfg = config.local;
  mkShellBin = name: file: writeShellScriptBin name (readFile file);

  rofi-wifi = mkShellBin "rofi-wifi" ./scripts/wifi.sh;
  rofi-bluetooth = mkShellBin "rofi-bluetooth" ./scripts/bluetooth.sh;
  rofi-powermenu = mkShellBin "rofi-powermenu" ./scripts/powermenu.sh;
in
{
  options.local.rofi.enable = mkOption {
    type = types.bool;
    default = cfg.hyprland.enable;
  };
  config = mkIf cfg.rofi.enable {
    home.packages = with pkgs; [ rofi-wifi rofi-bluetooth rofi-powermenu ];
    programs.rofi = {
      enable = true;
      package = pkgs.rofi-wayland;
      theme = ./gruvbox-dark.rasi;
    };
    local.launcher = "${pkgs.rofi-wayland}/bin/rofi";
    #local.wifi = "${rofi-wifi}/bin/rofi-wifi";
    #local.bluetooth = "${rofi-bluetooth}/bin/rofi-bluetooth";
  };
}
