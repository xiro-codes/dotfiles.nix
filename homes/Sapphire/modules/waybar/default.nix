{
  pkgs,
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.local;

  waybar-server = pkgs.writeShellScriptBin "waybar-server" ''
    source /etc/profile
    ${pkgs.waybar}/bin/waybar
  '';
in {
  options.local.waybar = {
    enable = mkOption {
      type = types.bool;
      default = cfg.hyprland.enable;
    };
  };
  config = mkIf (cfg.waybar.enable) {
    home.packages = with pkgs; [pavucontrol jq wttrbar];
    programs.waybar = {
      enable = true;
      style = ./style.2.css;
    };
    xdg.configFile."waybar/config".source = ./config.2.json;

    systemd.user.services.waybar = {
      Unit = {
        Description = "Waybar daemon";
        After = ["hyprland-session.target"];
      };
      Install = {WantedBy = ["hyprland-session.target"];};
      Service = {
        TimeoutStartSec = 120;
        ExecStart = "${waybar-server}/bin/waybar-server";
        ExecReload = "kill -SIGUSR2 $MAINPID";
        Restart = "on-failure";
        RestartSec = 20;
        KillMode = "mixed";
      };
    };
  };
}
