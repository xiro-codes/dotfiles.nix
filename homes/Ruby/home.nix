{
  config,
  pkgs,
  ...
}: {
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "tod";
  home.homeDirectory = "/home/tod";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "23.05"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    unzip
    unrar
    p7zip
    heroic
    ryujinx
    pcsx2
    ppsspp-sdl-wayland
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # You can also manage environment variables but you will have to manually
  # source
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/tod/etc/profile.d/hm-session-vars.sh
  #
  # if you don't want to manage your shell through Home Manager.
  home.sessionVariables = {
    # EDITOR = "emacs";
  };

  # Let Home Manager install and manage itself.
  programs = {
    home-manager.enable = true;
    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
    git = {
      enable = true;
      userName = "tdavis";
      userEmail = "me@tdavis.dev";
      extraConfig = {
        credential.helper = "store";
        safe.directory = "*";
      };
    };
    eza = {
      enable = true;
    };
    zoxide = {
      enable = true;
    };

    fish = {
      enable = true;
      shellAbbrs = {
        ls = "eza --icons";
        gcd = ''git commit -m "$(date)"'';
      };
      interactiveShellInit = ''
        set -g fish_color_normal 3760bf
        set -g fish_color_command 007197
        set -g fish_color_keyword 9854f1
        set -g fish_color_quote 8c6c3e
        set -g fish_color_redirection 3760bf
        set -g fish_color_end b15c00
        set -g fish_color_error f52a65
        set -g fish_color_param 7847bd
        set -g fish_color_comment 848cb5
        set -g fish_color_selection --background=b6bfe2
        set -g fish_color_search_match --background=b6bfe2
        set -g fish_color_operator 587539
        set -g fish_color_escape 9854f1
        set -g fish_color_autosuggestion 848cb5

        set -g fish_pager_color_progress 848cb5
        set -g fish_pager_color_prefix 007197
        set -g fish_pager_color_completion 3760bf
        set -g fish_pager_color_description 848cb5
        set -g fish_pager_color_selected_background --background=b6bfe2
        zoxide init fish | source
        fish_vi_key_bindings
        set -g snorin_chevrons green green green
      '';
    };
  };
}
