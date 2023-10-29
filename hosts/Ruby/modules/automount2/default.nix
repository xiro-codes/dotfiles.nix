{
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (lib) mkIf mkMerge mkOption types mdDoc mkEnableOption;
  inherit (lib.strings) concatMapStringsSep;

  cfg = config.jovian.steam;

  automount = let
    inherit
      (pkgs)
      writeShellApplication
      util-linux
      bash
      procps
      systemd
      steam
      ;
  in
    writeShellApplication {
      name = "automount";
      runtimeInputs = [util-linux procps bash systemd steam];
      text = import ./script.nix {inherit (cfg) user;};
    };
in {
  options.local.automount-v2 = {
    enable = mkEnableOption "Automatically mount drives and add its Steamlibrary if available.";

    user = mkOption {
      type = types.str;
      default = cfg.user;
      description = mdDoc "The user steam is running with.";
    };

    patterns = mkOption {
      type = types.listOf types.str;
      default = ["sd[a-z][0-9]"];
      description = mdDoc ''
        A list of glob patterns for selecting devices to automount.
      '';
    };
  };
  config = mkIf config.local.automount-v2.enable {
    services.udev.extraRules =
      concatMapStringsSep "\n" (pattern: ''
        KERNEL=="${pattern}", ACTION=="add", RUN+="${pkgs.systemd}/bin/systemctl start --no-block jovian-automount@%k.service"
        KERNEL=="${pattern}", ACTION=="remove", RUN+="${pkgs.systemd}/bin/systemctl stop --no-block jovian-automount@%k.service"
      '')
      cfg.automount.patterns;

    systemd.services."jovian-automount@".serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStart = "${automount}/bin/automount add %i";
      ExecStop = "${automount}/bin/automount remove %i";
    };
  };
}
