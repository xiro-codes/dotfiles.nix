{
  pkgs,
  config,
  lib,
  ...
}: let
  inherit (lib) mkEnableOption mkOption mkIf types;
  cfg = config.rice;
in {
  imports = [
    ./nnn
    ./neovim
    ./kitty
    ./ranger
    ./sway
    ./mako
    ./waybar
    ./wofi
    ./hyprland
    ./fuzzel
    ./mpd
  ];
  options.rice = {
    enable = mkEnableOption "Enable custom tweaks most UX and Sytle focused.";
    extraPackages = mkOption {
      type = types.listOf types.package;
      default = [];
    };
    editor = mkOption { type = types.str; };
    fileManager = mkOption { type = types.str; };
  };

  config = mkIf (cfg.enable) {
    home = {
      sessionVariables = {
        EDITOR = cfg.editor;
        VISUAL = cfg.editor;
        FILEMANAGER = cfg.fileManager;
      };
      packages = cfg.extraPackages ++ [

      ];
    };
  };
}
