{ pkgs
, config
, lib
, ...
}:
with lib; let
  cfg = config.local;
  variables = config.home.sessionVariables;

  lock = pkgs.writeShellScriptBin "swaylock" ''
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
  '';
  idle-enable = pkgs.writeShellScriptBin "idle-enable" ''
    if ! [ -e "~/.idle" ]; then
      ${pkgs.swayidle}/bin/swayidle -w timeout 1200 "${pkgs.hyprland}/bin/hyprctl dispatch dpms off" \
                                      timeout 1800 "${lock}/bin/swaylock" \
                                     resume "${pkgs.hyprland}/bin/hyprctl dispatch dpms on" \
                                     before-sleep "${lock}/bin/lock" &
      touch /home/tod/.idle
    else
      notify-send "Already Running Idle"
    fi
  '';
  idle-disable = pkgs.writeShellScriptBin "idle-disable" ''
    if [ -e "/home/tod/.idle" ]; then
      notify-send "Disable Idle Locking"
      pkill swayidle
      rm /home/tod/.idle
    else
      notify-send "Idle not running"
    fi
  '';

  sunset = pkgs.writeShellScriptBin "sunset" ''
    ${pkgs.wlsunset}/bin/wlsunset -S 6:00 -s 17:00
  '';

  bg-set = pkgs.writeShellScriptBin "bg-set" ''
    ${pkgs.swaybg}/bin/swaybg -i ${cfg.hyprland.wallpaperPath}
  '';
  paste-menu = pkgs.writeShellScriptBin "paste-menu" ''
    wtype "$(cliphist list | rofi -dmenu | cliphist decode )"
  '';
  swayimg = pkgs.writeShellScriptBin "swayimg" ''
    ${pkgs.swayimg}/bin/swayimg --class=swayimg $@
  '';
in
{
  options.local.hyprland = {
    enable = mkOption {
      type = types.bool;
      default = cfg.enable;
    };
    wallpaperPath = mkOption {
      type = types.str;
      default = "~/.wallpaper";
    };
  };
  config = mkIf (cfg.hyprland.enable) {
    home.packages = with pkgs; ([
      wl-clipboard
      libnotify
      easyeffects
      cliphist
      wtype
      wlogout
      bc
    ]) ++ [
      idle-enable
      idle-disable
      lock
      bg-set
      sunset
      paste-menu
      swayimg
    ];
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
          shadow_offset = "3 8";
          "col.shadow" = "rgba(00000099)";
          inactive_opacity = "0.7";
          active_opacity = "0.9";
          fullscreen_opacity = "1";
        };
        "$mod" = "ALT_L";
        "$super" = "SUPER_L";
        windowrule = [
          "float, ^(mkitty)$"
          "float, ^(pavucontrol)$"
          "float, ^(pcmanfm)$"
          "float, ^(fkitty)$"
          "float, ^(swayimg)$"
          "float, ^(feh)$"
          "float, title:^(btop)"
        ];
        exec-once = [
          "wl-paste --type text --watch cliphist store"
          "wl-paste --type image --watch cliphist store"
          "steam -silent"
          "${pkgs.easyeffects}/bin/easyeffects --gapplication-service &"
          "${idle-enable}/bin/idle-enable"
          "${bg-set}/bin/bg-set"
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
          "$mod_SHIFT, Return, exec, ${variables.TERMINAL} --class=fkitty"
          "$mod, E, exec, ${variables.EDITOR}"
          "$mod_SHIFT, E, exec, ${variables.FILEMANAGER}"
          "$mod, P, exec, ${variables.LAUNCHER} -show drun -show-icons"
          "$mod_SHIFT, P, exec, ${variables.LAUNCHER} -show run -show-icons"
          "$mod, V, exec, paste-menu"
          "$mod_SHIFT, Q, killactive"

          "$mod_SHIFT, Backspace, exec, rofi -show power-menu -modi power-menu:rofi-powermenu"
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
          "$mod,mouse:272, movewindow"
          "$mod,mouse:273, resizewindow"
        ];
      };
      hyprland.extraConfig = ''
      '';
    };
  };
}
