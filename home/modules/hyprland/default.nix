{
  pkgs,
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.local;
in {
  options.local.hyprland = {
    enable = mkOption {
      type = types.bool;
      default = cfg.enable;
    };
  };
  config = mkIf (cfg.hyprland.enable) {
    home.packages = [pkgs.swaybg];
    wayland.windowManager = {
      hyprland.enable = true;
      hyprland.systemdIntegration = true;
      hyprland.settings = {
        general = {
          border_size = "4";
          "col.active_border" = "rgba(33ccffee)";
          "col.inactive_border" = "rgba(595959aa)";
        };
        decoration = {
          rounding = "5";
          shadow_offset = "0 5";
          "col.shadow" = "rgba(00000099)";
        };
        "$mod" = "ALT_L";
        exec-once = [
          "wl-paste --type text --watch cliphist store"
          "steam -silent"
          "swaybg -i ~/.wallpaper"
        ];
        monitor = [
          "DP-2,1920x1080@60,0x1080,1"
          "DP-3,1920x1080@60,0x0,1"
        ];
        workspace = [
          "DP-2,1"
          "DP-2,2"
          "DP-2,3"
          "DP-3,4"
          "DP-3,5"
          "DP-3,6"
        ];
        bind = [
          "$mod, Return, exec, kitty"
          "$mod, P, exec, fuzzel"

          "$mod_SHIFT,Q, killactive"
          "$mod, F, fullscreen"
          "$mod_SHIFT, F, togglefloating"

          "$mod, H, movefocus, l"
          "$mod, J, movefocus, d"
          "$mod, K, movefocus, u"
          "$mod, L, movefocus, r"

          "$mod, U, workspace, 1"
          "$mod, I, workspace, 2"
          "$mod, O, workspace, 3"

          "$mod_SHIFT, U, movetoworkspace, 1"
          "$mod_SHIFT, I, movetoworkspace, 2"
          "$mod_SHIFT, O, movetoworkspace, 3"

          "$mod, M, workspace, 4"
          "$mod, comma, workspace, 5"
          "$mod, period, workspace, 6"

          "$mod_SHIFT, M, movetoworkspace, 4"
          "$mod_SHIFT, comma,   movetoworkspace, 5"
          "$mod_SHIFT, period, movetoworkspace, 6"
        ];
        bindm = [
          "$mod, mouse:272, movewindow"
          "$mod, mouse:273, resizewindow"
        ];
      };
      hyprland.extraConfig = ''
      '';
    };
  };
}
