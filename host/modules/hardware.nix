{ config, lib, pkgs, ... }:
let
  inherit (lib) mkIf mkOption types;
  cfg = config.local;
in
{
  imports = [

  ];
  options.local.hardware= {
    enable = mkOption {
      type = types.bool;
      default = cfg.enable;
    };
  };
  config = mkIf cfg.hardware.enable {
    hardware = {
      bluetooth.enable = true;
      opengl.enable = true;
      enableRedistributableFirmware = true;
    };
  };
}
