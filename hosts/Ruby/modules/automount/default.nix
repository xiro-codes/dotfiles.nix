{ lib
, config
, pkgs
, ...
}:
let
  cfg = config.local.automount;
  script = pkgs.writeShellScriptBin "automount" ''
    function mount_drive () {
      label="$(${pkgs.util-linux}/bin/lsblk -noLABEL $1)"
      if [ -z "$label" ]; then
        label="$(${pkgs.util-linux}/bin/lsblk -noUUID $1)"
      fi
      mkdir -p "/mnt/$label"
      chown ${cfg.user}:users "/mnt/$label"
      ${pkgs.util-linux}/bin/mount "$1" "/mnt/$label"
      sleep 5
      urlencode()
      {
        [ -z "$1" ] || echo -n "$@" | ${pkgs.util-linux}/bin/hexdump -v -e '/1 "%02x"' | sed 's/\(..\)/%\1/g'
      }
      mount_point="$(${pkgs.util-linux}/bin/lsblk -noMOUNTPOINT $1)"
      if [ -z "$mount_point" ]; then
        echo "Failed to mount "$1" at /mnt/$label"
      else
        mount_point="$mount_point/SteamLibrary"
        url=$(urlencode "''${mount_point}")
        if ${pkgs.procps}/bin/pgrep -x "steam" > /dev/null; then
          echo "Added Folder to steam library $url"
          systemd-run -M 1000@ --user --collect --wait sh -c "${pkgs.steam}/bin/steam 'steam://addlibraryfolder/''${url}'"
        fi
      fi
    }
    if [ "$1" = "remove" ]; then
      exit 0
    else
      mount_drive "/dev/$2"
    fi
    exit 0;
  '';
in
with lib; {
  imports = [
  ];
  options.local.automount = {
    enable = mkEnableOption "enable automount system";
    user = mkOption {
      type = types.str;
      default = "deck";
    };
    patterns = mkOption {
      type = types.listOf types.str;
      default = [
        "sd[a-z][0-9]"
      ];
      description = mdDoc "udev pattern for drives to mount";
    };
  };
  config = mkIf cfg.enable {
    services.udev = {
      extraRules = strings.concatLines (map
        (pattern: ''
          KERNEL=="${pattern}", ACTION=="add", RUN+="${pkgs.systemd}/bin/systemctl start --no-block jovian-automount@%k.service"
          KERNEL=="${pattern}", ACTION=="remove", RUN+="${pkgs.systemd}/bin/systemctl stop --no-block jovian-automount@%k.service"
        '')
        cfg.patterns);
    };
    systemd.services."jovian-automount@" = {
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
        ExecStart = "${script}/bin/automount add %i";
        ExecStop = "${script}/bin/automount remove %i";
      };
    };
  };
}
