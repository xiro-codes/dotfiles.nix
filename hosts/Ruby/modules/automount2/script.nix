{user}: ''
  urlencode()
  {
     # From https://gist.github.com/HazCod/da9ec610c3d50ebff7dd5e7cac76de05
     [ -z "$1" ] || echo -n "$@" | hexdump -v -e '/1 "%02x"' | sed 's/\(..\)/%\1/g'
  }
  mount_drive()
  {
     label="$(lsblk -noLABEL "$1")"
     if [ -z "$label" ]; then
       label="$(lsblk -noUUID "$1")"
     fi

     mkdir -p "/mnt/$label"
     chown ${user} -R "/mnt/$label"
     mount "$1" "/mnt/$label"
     sleep 5

     mount_point="$(lsblk -noMOUNTPOINT "$1")"
     if [ -z "$mount_point" ]; then
       echo "Failed to mount ""$1"" at /mnt/$label"
     else
       if [ -d "$mount_point/SteamLibrary" ]; then
         library="$mount_point/SteamLibrary"
         url=$(urlencode "''${library}")
         if pgrep -x "steam" > /dev/null; then
           systemd-run -M 1000@ --user --collect --wait sh -c "steam steam://addlibraryfolder/''${url}"
         fi
       else
         echo "no steam library on drive"
       fi
     fi
  }
  umount_drive()
  {
     label="$(lsblk -noLABEL "$1")"
     if [ -z "$label" ]; then
       label="$(lsblk -noUUID "$1")"
     fi
     mount_point="$(lsblk -noMOUNTPOINT "$1")"
     if [ -z "$mount_point" ]; then
       echo "Failed to mount ""$1"" at /mnt/$label"
     else
       if [ -d "$mount_point/SteamLibrary" ]; then
         library="$mount_point/SteamLibrary"
         url=$(urlencode "''${library}")
         if pgrep -x "steam" > /dev/null; then
           systemd-run -M 1000@ --user --collect --wait  sh -c "steam steam://removelibraryfolder/''${url}"
         fi
         sleep 5
         umount "$mount_point"
       else
         echo "no steam library on drive"
       fi
     fi
  }

  if [ "$1" = "remove" ]; then
     umount_drive "/dev/$2"
  else
     mount_drive "/dev/$2"
  fi
  exit 0
''
