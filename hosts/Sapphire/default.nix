{
  system,
  version,
  hostName,
  self,
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
      pulseaudioFull
      steam-run
    ];
  };

  networking.hostName = hostName;
  security.sudo.wheelNeedsPassword = false;
  security.polkit.enable = true;
  security.pam.services.swaylock = {};
  environment.etc."nixos-backups/${self.shortRev}".source = self.outPath;  
  virtualisation.waydroid.enable = true;
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
    kdeconnect.enable = true;
  };
  services = {
    pipewire = {
      enable = true;
      pulse.enable = true;
    };
    xserver = {
      enable = false;
      displayManager.gdm.enable = false;
      desktopManager.plasma5.enable = false;
      excludePackages = [pkgs.xterm];
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
    logind.extraConfig = ''
      IdleAction=lock
      IdleActionSec=30s
      StopIdleSessionSec=15s
    '';
    openssh.enable = true;
    gvfs.enable = true;
    udisks2.enable = true;
    devmon.enable = true;
    postgresql = {
      enable = true;
      initialScript = pkgs.writeText "init" ''
        CREATE USER master SUPERUSER WITH LOGIN PASSWORD 'password';
        CREATE DATABASE main;
      '';
    };
  };
  system.stateVersion = version;
}
