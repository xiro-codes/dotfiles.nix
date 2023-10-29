{ pkgs
, config
, lib
, ...
}:
with lib; let
  cfg = config.local;
  variables = config.home.sessionVariables;
  hide_waybar = pkgs.writeShellScriptBin "hide_waybar" "kill -SIGUSR1 $(pidof waybar)";
  reduce = f: list: (foldl f (head list) (tail list));

  sunset = pkgs.writeShellScriptBin "sunset" ''
    ${pkgs.wlsunset}/bin/wlsunset -S 6:00 -s 17:00
  '';
  paste-menu = pkgs.writeShellScriptBin "paste-menu" ''
    wtype "$(cliphist list | rofi -dmenu | cliphist decode )"
  '';
  swaylock = pkgs.writeShellScriptBin "swaylock" ''
    ${pkgs.swaylock-effects}/bin/swaylock --screenshots \
          --clock \
          --indicator \
          --datestr "%m-%d" \
          --effect-blur 7x5 \
          --ring-color 282828\
          --key-hl-color 9ECE6A \
          --text-color 7DCFFF \
          --line-color 00000000 \
          --inside-color 00000088 \
          --separator-color 00000000 \
          --effect-pixelate 40
  '';
  idle = pkgs.writeShellScriptBin "idle" ''
      ${pkgs.swayidle}/bin/swayidle lock "${swaylock}/bin/swaylock"
  '';
  disable = pkgs.writeShellScriptBin "disable" ''
    hyprctl dispatch submap clean && \
    notify-send -w "Keybinds disabled dismiss to Renable" -t 0 && \
    notify-send -w "Keybinds Renabled $(hyprctl dispatch submap reset)"
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

      monitors = mkOption {
        default = [ ];
        type = with types; listOf (submodule {
          options = {
            enabled = mkOption { type = bool; default = true; };
            name = mkOption { type = str; };
            width = mkOption { type = int; };
            height = mkOption { type = int; };
            rate = mkOption { type = int; };
            scale = mkOption { type = int; };
            x = mkOption { type = int; };
            y = mkOption { type = int; };
            workspaces = mkOption { type = listOf int; };
          };
        });
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
      swayidle
    ]) ++ [
      paste-menu
      hide_waybar
      swaylock
      idle
      disable
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
          "float, title:^(game)"
          "nofocus, com-group_finity-mascot-Main"
          "noblur, com-group_finity-mascot-Main"
          "noshadow, com-group_finity-mascot-Main"
          "noborder, com-group_finity-mascot-Main"
          "float, com-group_finity-mascot-Main"
        ];
        exec-once = [
          "wl-paste --type text --watch cliphist store"
          "steam -silent"
          #"${pkgs.easyeffects}/bin/easyeffects --gapplication-service &"
          "${pkgs.swaybg}/bin/swaybg -i ${cfg.hyprland.wallpaperPath}"
          ''${pkgs.swayidle}/bin/swayidle lock "${swaylock}/bin/swaylock"''
        ];
        monitor = map
          (m:
            let
              resolution = "${toString m.width}x${toString m.height}@${toString m.rate}";
              position = "${toString m.x}x${toString m.y}";
            in
            "${m.name},${if m.enabled then "${resolution},${position},${toString m.scale}" else "disable"}")
          (cfg.hyprland.monitors);

        workspace = reduce (cs: s: cs ++ s) (map (m: map (w: "${m.name}, ${toString w}") m.workspaces) (cfg.hyprland.monitors));

        bind = [
          "$mod, Return, exec, ${variables.TERMINAL}"
          "$mod_SHIFT, Return, exec, ${variables.TERMINAL} --class=fkitty"
          "$mod, E, exec, ${variables.EDITOR}"
          "$mod_SHIFT, E, exec, ${variables.FILEMANAGER}"

          "$mod, P, exec, ${variables.LAUNCHER} -show drun -show-icons"
          "$mod_SHIFT, P, exec, ${variables.LAUNCHER} -show run -show-icons"
          "$mod, Space, exec, ${variables.LAUNCHER} -show window -show-icons"

          "$mod, V, exec, paste-menu"
          "$mod_SHIFT, Q, killactive"

          "$mod_SHIFT, Backspace, exec, rofi -show power-menu -modi power-menu:rofi-powermenu"
          "$mod, F, fullscreen"
          "$mod_SHIFT, F, togglefloating"
          "$mod, X, exec, ${hide_waybar}/bin/hide_waybar"
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

          "$mod, Backspace, exec, ${disable}/bin/disable"
        ];
        bindm = [
          "$mod,mouse:272, movewindow"
          "$mod,mouse:273, resizewindow"
        ];
      };
      hyprland.extraConfig = ''
        bind=$mod,Backspace, submap, clean
        submap=clean
        bind=$mod,Backspace, exec, notify-send "Dismiss"
        submap=reset
      '';
    };
    xdg.configFile."hypr/hyprpaper.conf".text =  ''
      preload = ~/Pictures/Wallpapers/Gruvbox/smile.jpg
      preload = ~/Pictures/Wallpapers/Gruvbox/city.png
    '';
    assertions = [
      { assertion = config.local.rofi.enable; message = "hyprland depends on rofi"; }
    ];
  };
}
