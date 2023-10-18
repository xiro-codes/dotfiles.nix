{ config, pkgs, ... }:

{
  imports = [
    ./modules
  ];
  home.username = "tod";
  home.homeDirectory = "/home/tod";

  home.stateVersion = "23.05"; # Please read the comment before changing.
  nixpkgs.config.allowUnfree = true;
  home.packages = with pkgs;[
    librewolf
    nerdfonts
    unzip
    p7zip
    sysstat
    unrar
    pcmanfm
    heroic
    btop
    vlc
    xarchiver
    feh
    qpwgraph
    ppsspp-sdl-wayland
    pcsx2
    ryujinx
    yuzu-mainline
    mangohud
  ];

  fonts.fontconfig.enable = true;
  local = {
    enable = true;
    fileManager = "${pkgs.pcmanfm}/bin/pcmanfm";
    hyprland.monitors = [
          "DP-1,1920x1080@60,0x1080,1"
          "DP-2,1920x1080@60,0x0,1"
    ];
    waybar.theme = "gruvbox";
  };

  home.file = { };
  gtk = {
    enable = true;
    theme= {
      package = pkgs.gruvbox-dark-gtk;
      name = "gruvbox-dark";
    };
    iconTheme = {
      package = pkgs.gruvbox-dark-icons-gtk;
      name = "oomox-gruvbox-dark";
    };
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
    obs-studio = {
      enable = true;
      plugins = [
        pkgs.obs-studio-plugins.wlrobs
        pkgs.obs-studio-plugins.obs-pipewire-audio-capture
      ];
    };
  };
}
