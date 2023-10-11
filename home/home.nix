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
    wl-clipboard
    libnotify
    p7zip
    sysstat
    pcmanfm
    heroic
    btop
    vlc
    nwg-look
    gruvbox-dark-gtk
    breeze-icons
    pgadmin4
    obsidian
    easyeffects
    wlsunset
    lutris
  ];

  fonts.fontconfig.enable = true;
  local = {
    enable = true;
    fileManager = "${pkgs.pcmanfm}/bin/pcmanfm";
  };

  home.file = { };
  gtk = {
    theme= {
      package = pkgs.gruvbox-dark-gtk;
      name = "gruvbox-dark";
    };
  };
  # Let Home Manager install and manage itself.
  programs = {
    home-manager.enable = true;
    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
    starship = {
      enable = true;
      enableFishIntegration = true;
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
  };
}
