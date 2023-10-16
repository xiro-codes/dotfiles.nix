{
  pkgs,
  config,
  lib,
  ...
}: let
  inherit (lib) mkEnableOption mkOption mkIf types;
  cfg = config.local;
in {
  imports = [
    ./nnn
    ./neovim
    ./kitty
    ./ranger
    ./sway
    ./mako
    ./waybar
    ./rofi
    ./hyprland
    ./fuzzel
    ./mpd
    ./fish
  ];
  options.local = {
    enable = mkEnableOption "Enable custom tweaks most UX and Sytle focused.";
    extraPackages = mkOption {
      type = types.listOf types.package;
      default = [];
    };
    editor = mkOption {type = types.str;};
    fileManager = mkOption {type = types.str;};
    terminal = mkOption {type = types.str;};
    launcher = mkOption {type = types.str;};
  };

  config = mkIf (cfg.enable) {
    home = {
      sessionVariables = {
        EDITOR = cfg.editor;
        VISUAL = cfg.editor;
        FILEMANAGER = cfg.fileManager;
        TERMINAL = cfg.terminal;
        LAUNCHER = cfg.launcher;
      };
      packages =
        cfg.extraPackages
        ++ [
        ];
    };
  };
}
