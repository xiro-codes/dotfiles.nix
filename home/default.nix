{
  system,
  version,
  ...
}: {pkgs, ...}: {
  imports = [
    ./modules
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
  local = {
    enable = true;
    fileManager = "${pkgs.pcmanfm}/bin/pcmanfm";
  };
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
  };
}
