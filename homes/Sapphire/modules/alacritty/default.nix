{
  pkgs,
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf mkOption types;
  cfg = config.local;
in {
  imports = [];
  options.local.alacritty = {
    enable = mkOption {
      type = types.bool;
      default = cfg.enable;
    };
    theme = {
      name = mkOption {
        type = types.str;
        default = "gruvbox_dark";
      };
      repo = mkOption {
        type = types.str;
        default = "https://raw.githubusercontent.com/wdomitrz/kitty_gruvbox_theme/master/";
      };
      hash = mkOption {
        type = types.str;
        default = "sha256-l9qWf09W0rMUCo5fJngFFWOrrOfPM9yI1RkfZUL6Stc=";
      };
    };
  };
  config = mkIf (cfg.kitty.enable) {
    local.terminal = "${pkgs.alacritty}/bin/alacritty";
    programs.alacritty = {
      enable = true;
      font = {
        package = pkgs.cascadia-code;
        name = "CascadiaCode";
        size = 10;
      };
      extraConfig = lib.readFile (pkgs.fetchurl {
        url = "${cfg.kitty.theme.repo}/${cfg.kitty.theme.name}.conf";
        hash = cfg.kitty.theme.hash;
      });
    };
  };
}
