{ config, lib, pkgs, ... }:
let
  inherit (lib) mkIf mkOption types mkEnableOption;
  cfg = config.local;
in
{
  imports = [
  ];
  options.local.networking = {
    enable = mkOption {
      type = types.bool;
      default = cfg.enable;
    };
  };
  config = mkIf cfg.networking.enable {
    networking = {
      useDHCP = false;
      interfaces.wlan0.useDHCP = true;
      firewall.allowedTCPPorts = [ 24070 27036 ];
      firewall.enable = false;
      networkmanager = {
        enable = true;
        wifi.backend = "iwd";
      };
      wireless = {
        enable = false;
        iwd.enable = true;
      };
    };

  };
}
