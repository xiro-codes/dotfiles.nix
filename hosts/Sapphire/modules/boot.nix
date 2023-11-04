{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf mkOption mkEnableOption types;
  cfg = config.local;
in {
  imports = [];
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
        timeout = lib.mkForce 5;
      };
      kernelPackages = pkgs.linuxKernel.packages.linux_5_10;
      kernelModules = ["kvm-amd"];
      kernelParams = [ ];
      initrd.kernelModules = [];
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
