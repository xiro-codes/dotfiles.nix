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
  options.local.kitty = {
    enable = mkOption {
      type = types.bool;
      default = cfg.enable;
    };
    theme = {
      name = mkOption {
        type = types.str;
        default = "tokyonight_day";
      };
      repo = mkOption {
        type = types.str;
        default = "https://raw.githubusercontent.com/folke/tokyonight.nvim/main/extras/kitty/";
      };
      hash = mkOption {
        type = types.str;
        default = "sha256-UgbGeUMKrTjYNyH3MBrh7znAQLz375u8KpDGwDBurkc=";
      };
    };
  };
  config = mkIf (cfg.kitty.enable) {
    local.terminal = "${pkgs.kitty}/bin/kitty";
    programs.kitty = {
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
