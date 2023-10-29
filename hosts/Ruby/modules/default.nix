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
    ./boot.nix
    ./environment.nix
    ./networking.nix
    ./hardware.nix
    ./nixos.nix
    ./automount
    ./automount2
  ];
  options.local = {
    enable = mkEnableOption "Simplfy man host config";
    packages = mkOption {
      type = types.listOf types.package;
      default = [];
    };
  };
  config = mkIf cfg.enable {
    i18n.defaultLocale = "en_US.UTF-8";
    time.timeZone = "America/Chicago";
  };
}
