{
  system,
  version,
  hostName,
}: {
  config,
  lib,
  pkgs,
  ...
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
    {device = "/dev/disk/by-label/SWAP";}
  ];


  users.users.tod = {
    name = "tod";
    isNormalUser = true;
    extraGroups = ["wheel" "audio" "networkmanager" "input" "uinput" "dialout"];
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
  };

  system.stateVersion = version;
}
