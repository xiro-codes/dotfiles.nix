{
  pkgs,
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.local;
  ;;;; 
in {
  options.local.gemini.enable = mkOption {
    type = types.bool;
  };
  config = mkIf cfg.gemini.enable {
    systemd.user.services.gemini = {
      Unit = {
        Description = "Gemini Server";
        After = [ "network.target" ];
      };
      Install = { WantedBy = ["default.target"];};
      Service = { ExecStart = "${pkgs.agate}/bin/agate ";};
    };
  };
}
