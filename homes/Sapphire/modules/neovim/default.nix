{
  pkgs,
  config,
  lib,
  ...
}: let
  inherit (lib) mkEnableOption mkOption mkIf types;
  inherit (pkgs) writeShellApplication writeShellScriptBin;
  inherit (builtins) readFile toString;
  cfg = config.local;
  nvr = writeShellApplication {
    name = "nvr";
    runtimeInputs = with pkgs; [
      neovim-remote
    ];
    text = ''
      nvr --servername localhost:"$1" "''${@:2}"
    '';
  };
  nvs = writeShellScriptBin "nvs" ''nvim --headless --listen localhost:"$1" '';
  nvc = writeShellApplication {
    name = "nvc";
    runtimeInputs = with pkgs; [neovide];
    text = ''
      neovide --server=localhost:"$1" "''${@:2}"
    '';
  };
in {
  imports = [];
  options.local.neovim = {
    enable = mkOption {
      type = types.bool;
      default = cfg.enable;
    };
  };
  config = mkIf (cfg.neovim.enable) {
    home.packages = [
      pkgs.neovide
      pkgs.rust-analyzer
      pkgs.nil
      pkgs.rnix-lsp
      pkgs.alejandra
      pkgs.nixpkgs-fmt
      pkgs.fzf
      pkgs.universal-ctags
      pkgs.python311Packages.autopep8
      pkgs.nodejs
      nvr
      nvc
      nvs
    ];
    local.editor = "nvim";

    programs.neovim = {
      enable = true;

      extraLuaConfig = readFile ./init.lua;

      plugins = with pkgs.vimPlugins; [
        vim-nix
        dart-vim-plugin
        vim-toml

        lightline-vim
        lightline-gruvbox-vim
        gruvbox-nvim

        ranger-vim

        nvim-lspconfig
        nvim-cmp
        cmp-nvim-lsp
        luasnip
        cmp_luasnip
        nvim-surround
        rust-tools-nvim
        flutter-tools-nvim
        plenary-nvim
        copilot-vim
      ];
      coc = {
        enable = false;
      };
    };
  };
}
