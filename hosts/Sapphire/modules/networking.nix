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
      firewall.allowedTCPPortRanges = [{from = 27015; to = 27050;}];
      firewall.allowedUDPPorts = [];
      firewall.allowedUDPPortRanges = [ {from = 27015; to = 27050;} ];
      firewall.enable = true;
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
