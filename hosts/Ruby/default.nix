{
  system ? "x86_64-linux",
  version ? "23.05",
  pkgs,
}: {
  config,
  lib,
  pkgs,
}:
with pkgs; {
  imports = [
    ./modules
  ];

  local = {
    enable = true;
    automount = {
      enable = true;
      user = "tod";
    };
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
  };
  swapDevices = [{device = "/dev/disk/by-label/SWAP";}];

  users.users.tod = {
    name = "tod";
    isNormalUser = true;
    extraGroups = ["wheel" "audio" "networkmanager"];
    shell = fish;
    initialPassword = "ruby";
  };
  security.rtkit.enable = true;
  services = {
    openssh = {
      enable = true;
      ports = [4815];
    };
    pipewire.enable = true;
  };
  programs = {
    fish.enable = true;
    git.enable = true;
    steam.enable = true;
  };
  services.xserver = {
    desktopManager.plasma5.enable = true;
  };
  environment.systemPackages = [xdg-user-dirs];

  jovian = {
    devices.steamdeck = {
      enable = true;
    };
    steam = {
      enable = true;
      user = "tod";
      autoStart = true;
      desktopSession = "plasma";
    };
  };
  system.stateVersion = version;
}
