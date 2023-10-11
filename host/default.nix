{ system
, version
, hostName
,
}: { config
   , lib
   , pkgs
   , ...
   }: {
  imports = [
    ./modules
  ];
  local = {
    enable = true;
    packages = with pkgs; [
      xdg-user-dirs
    ];
  };

  networking.hostName = hostName;
  security.sudo.wheelNeedsPassword = false;
  security.polkit.enable = true;
  security.pam.services.swaylock = { };
  fileSystems = {
    "/" = {
      label = "ROOT";
      fsType = "ext4";
    };
    "/boot" = {
      label = "BOOT";
      fsType = "vfat";
    };
    "/mnt/archive" = {
      label = "ARCHIVE";
      noCheck = true;
      fsType = "ntfs";
    };
    "/mnt/ssd" = {
      device = "/dev/vg.ssd/SSD";
      fsType = "ext4";
    };
    "/mnt/hdd" = {
      device = "/dev/vg.hdd/HDD";
      fsType = "ext4";
    };
  };
  swapDevices = [
    { device = "/dev/disk/by-label/SWAP"; }
  ];


  users.users.tod = {
    name = "tod";
    isNormalUser = true;
    extraGroups = [ "wheel" "audio" "networkmanager" "input" "uinput" "dialout" ];
    shell = pkgs.fish;
    password = "sapphire";
  };

  programs = {
    fish.enable = true;
    steam.enable = true;
    git.enable = true;
    hyprland.enable = true;
  };
  services = {
    pipewire = {
      enable = true;
      pulse.enable = true;
    };
    xserver = {
      enable = false;
      displayManager.sddm.enable = false;
      desktopManager.plasma5.enable = false;
      desktopManager.gnome.enable = false;
      desktopManager.enlightenment.enable = false;
      desktopManager.deepin.enable = false;
      desktopManager.budgie.enable = false;
      desktopManager.cinnamon.enable = false;
    };
    greetd = {
      enable = true;
      settings.default_session = {
        command = "${pkgs.hyprland}/bin/Hyprland";
        user = "tod";
      };
    };
    komga = {
      enable = true;
      port = 8090;
      openFirewall = true;
    };
    openssh.enable = true;
    postgresql = {
      enable = true;
      initialScript = pkgs.writeText "init" ''
        CREATE USER master SUPERUSER WITH LOGIN PASSWORD 'password';
        CREATE DATABASE main;
      '';
    };
  };
  environment.plasma5.excludePackages = with pkgs.libsForQt5; [
    elisa
    gwenview
    okular
    oxygen
    khelpcenter
    konsole
    plasma-browser-integration
    print-manager
  ];
  environment.gnome.excludePackages = (with pkgs; [
    gnome-photos
    gnome-tour
  ]) ++ (with pkgs.gnome; [
    cheese # webcam tool
    gnome-music
    gnome-terminal
    gedit # text editor
    epiphany # web browser
    geary # email reader
    evince # document viewer
    gnome-characters
    totem # video player
    tali # poker game
    atomix # puzzle game
  ]);
  system.stateVersion = version;
}
