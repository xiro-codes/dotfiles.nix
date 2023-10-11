{ pkgs
, config
, lib
, ...
}:
with lib; let
  cfg = config.local;
  variables = config.home.sessionVariables;
  lock-cmd = pkgs.writeShellScriptBin "lock" ''
    ${pkgs.swaylock-effects}/bin/swaylock --screenshots \
          --clock \
          --indicator \
          --datestr "%m-%d" \
          --effect-blur 7x5 \
          --ring-color 9AA5CE \
          --key-hl-color 9ECE6A \
          --text-color 7DCFFF \
          --line-color 00000000 \
          --inside-color 00000088 \
          --separator-color 00000000 \
          --effect-pixelate 40 \
          --fade-in 0.2 \
  '';
  idle-cmd = pkgs.writeShellScriptBin "idle" ''
    ${pkgs.swayidle}/bin/swayidle -w timeout 300 "${lock-cmd}/bin/lock" \
                                     timeout 600 "${pkgs.hyprland}/bin/hyprctl dispatch dpms off" \
                                     resume "${pkgs.hyprland}/bin/hyprctl dispatch dpms on" \
                                     before-sleep "${lock-cmd}/bin/lock"
  '';
  sunset = pkgs.writeShellScriptBin "sunset" ''
    ${pkgs.wlsunset}/bin/wlsunset -S 6:00 -s 17:00
  '';
in
{
  options.local.hyprland = {
    enable = mkOption {
      type = types.bool;
      default = cfg.enable;
    };
  };
  config = mkIf (cfg.hyprland.enable) {
    xdg.configFile."hypr/shader.glsl".source = ./shader.glsl;
    home.packages = [ pkgs.swaybg pkgs.swayidle idle-cmd lock-cmd];
    wayland.windowManager = {
      hyprland.enable = true;
      hyprland.systemd.enable = true;
      hyprland.settings = {
        general = {
          border_size = "2";
          "col.active_border" = "rgba(33ccffee)";
          "col.inactive_border" = "rgba(595959aa)";
        };
        decoration = {
          rounding = "10";
          shadow_offset = "0 5";
          "col.shadow" = "rgba(00000099)";
          inactive_opacity= "0.5";
          active_opacity= "0.9";
          fullscreen_opacity= "0.95";
          #screen_shader = "/home/tod/.config/hypr/shader.glsl";
        };
        "$mod" = "ALT_L";
        exec-once = [
          "wl-paste --type text --watch cliphist store"
          "steam -silent"
          "swaybg -i ~/.wallpaper"
          "easyeffects --gapplication-service &"
          "${idle-cmd}/bin/idle"
          "${lock-cmd}/bin/lock"
          "${sunset}/bin/sunset"
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
          "$mod, Return, exec, ${variables.TERMINAL}"
          "$mod, E, exec, ${variables.EDITOR}"
          "$mod_SHIFT, E, exec, ${variables.FILEMANAGER}"
          "$mod, P, exec, rofi -show drun"

          "$mod_SHIFT,Q, killactive"
          "$mod, F, fullscreen"
          "$mod_SHIFT, F, togglefloating"

          "$mod, H, movefocus, l"
          "$mod, J, movefocus, d"
          "$mod, K, movefocus, u"
          "$mod, L, movefocus, r"

          "$mod_SHIFT, H, movewindow, l"
          "$mod_SHIFT, J, movewindow, d"
          "$mod_SHIFT, K, movewindow, u"
          "$mod_SHIFT, L, movewindow, r"

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
