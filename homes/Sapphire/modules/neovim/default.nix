{
  pkgs,
  config,
  lib,
  ...
}: let
  inherit (lib) mkEnableOption mkOption mkIf types;
  inherit (builtins) readFile;
  cfg = config.local;
in {
  imports = [];
  options.local.neovim = {
    enable = mkOption {
      type = types.bool;
      default = cfg.enable;
    };
    port = mkOption {
      type = types.port;
      default = 6789;
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
      ];
      coc = {
        enable = false;
      };
    };

    #systemd.user.services.nvs= {
    #  Unit = {
    #    After = [ "sway-session.target" ];
    #  };
    #  Install = { WantedBy = [ "sway-session.target" ]; };
    #  Service = {
    #    ExecStart = "${nvs}/bin/nvs";
    #    Restart = "always";
    #  };
    #};
  };
}
