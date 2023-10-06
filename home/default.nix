{ system, version, ... }: { pkgs
                          , ...
                          }: {
  imports = [
    ./rice
  ];
  home = {
    stateVersion = version;
    packages = with pkgs; [
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
    ];
  };
  fonts.fontconfig.enable = true;
  rice.enable = true;
  programs = {
    home-manager.enable = true;
    fish.enable = true;
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
  };
}
