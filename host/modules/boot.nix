{ config, lib, pkgs, ... }:
let
  inherit (lib) mkIf mkOption mkEnableOption types;
  cfg = config.local;
in
{
  imports = [ ];
  options.local.boot = {
    enable = mkOption {
      type = types.bool;
      default = cfg.enable;
    };
  };
  config = mkIf cfg.boot.enable {
    boot = {
      loader = {
        efi.canTouchEfiVariables = true;
        systemd-boot.enable = true;
        timeout = 5;
      };
      kernelPackages = pkgs.linuxKernel.packages.linux_zen;
      kernelModules = [ "kvm-amd" ];
      kernelParams = [ ];
      initrd.availableKernelModules = [
        "xhci_pci"
        "ahci"
        "nvme"
        "usbhid"
        "sd_mod"
        "usb_storage"
      ];
    };
  };
}
