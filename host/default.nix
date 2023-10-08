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
  imports = [];
  i18n.defaultLocale = "en_US.UTF-8";
  time.timeZone = "America/Chicago";
  nixpkgs.config.allowUnfree = true;
  nix = {
    settings = {
      substituters = [
        "https://nix-community.cachix.org"
        "https://cache.nixos.org/"
      ];
      trusted-users = ["root" "tod"];
      trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];
    };
    extraOptions = ''
      extra-experimental-features = nix-command
      extra-experimental-features = flakes
      keep-outputs = true
      keep-derivations = true
    '';
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
    optimise = {
      automatic = true;
      dates = ["weekly"];
    };
  };

  hardware = {
    bluetooth.enable = true;
    opengl.enable = true;
    enableRedistributableFirmware = true;
  };
  boot = {
    loader = {
      efi.canTouchEfiVariables = true;
      systemd-boot.enable = true;
      timeout = 5;
    };
    kernelPackages = pkgs.linuxKernel.packages.linux_zen;
    kernelModules = ["kvm-amd"];
    kernelParams = [];
    initrd.availableKernelModules = [
      "xhci_pci"
      "ahci"
      "nvme"
      "usbhid"
      "sd_mod"
      "usb_storage"
    ];
  };
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
  networking = {
    inherit hostName;
    useDHCP = false;
    interfaces.wlan0.useDHCP = true;
    firewall.allowedTCPPorts = [24070 27036];
    networkmanager = {
      enable = true;
      wifi.backend = "iwd";
    };
    wireless = {
      enable = false;
      iwd.enable = true;
    };
  };
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
  };
  environment.variables = {
    CLUTTER_BACKEND = "wayland";
    GDK_BACKEND = "wayland";
    GDK_DPI_SCALE = "1";
    MOZ_ENABLE_WAYLAND = "1";
    QT_QPA_PLATFORM = "wayland";
    QT_QPA_PLATFORMTHEME = "qt5ct";
    QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
    WLR_NO_HARDWARE_CURSORS = "1";
    _JAVA_AWT_WM_NONREPARENTING = "1";
    _JAVA_OPTIONS = "-Dawt.useSystemAAFontSettings=on";
  };
  environment.systemPackages = with pkgs; [
    xdg-user-dirs
  ];
  system.stateVersion = version;
}
