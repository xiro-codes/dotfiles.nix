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
      ];
      local.editor = "${pkgs.neovide}/bin/neovide";

      programs.neovim = {
        enable = true;

        extraConfig = readFile ./init.vim;
        plugins = with pkgs.vimPlugins; ([
            lightline-vim
            vim-nix
            rust-tools-nvim
            vim-startify
            vim-toml
            vim-mustache-handlebars
            vista-vim
            fzf-vim
            nvim-lspconfig
            gruvbox-nvim
            nvim-treesitter.withAllGrammars
            lightline-gruvbox-vim
			nerdtree
            vim-devicons
            nvim-surround
            vim-grammarous
            coc-spell-checker
            coc-rust-analyzer
            coc-tsserver
            coc-tslint-plugin
            coc-markdownlint
          ]);
        coc = {
          enable = true;
          settings.languageserver = {
            rnix = {
              command = "${pkgs.rnix-lsp}/bin/rnix-lsp";
              filetypes = ["nix"];
            };
            rust-analyzer = {
              settings.rust-analyzer = {
                imports.granularity.group = "module";
              };
            };
            nil = {
              command = "${pkgs.nil}/bin/nil";
              filetypes = ["nix"];
              rootPatterns = ["flake.nix" "default.nix" "shell.nix"];
              settings.nil = {
                formatting.command = ["nixpkgs-fmt"];
                nix.flake = {
                  autoArchive = true;
                  autoEvalInputs = false;
                };
              };
            };
          };
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
