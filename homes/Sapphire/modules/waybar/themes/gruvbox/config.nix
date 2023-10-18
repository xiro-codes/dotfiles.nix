{pkgs}:[{
	"layer"= "top";
	"position"= "top";
	"mod"= "dock";
	"exclusive"= true;
	"passtrough"= false;
	"gtk-layer-shell"= true;
	"height"= 40;
	"modules-left"= [
		"clock"
		"custom/weather"
		"network"
		"cpu"
		"memory"
		"hyprland/workspaces"
	];
	"modules-center"= ["hyprland/window"];
	"modules-right"= [
		"tray"
		"pulseaudio"
		"bluetooth"
		"mpd"
	];
	"network"= {
		"format-wifi"= "  {essid}";
		"format-ethernet"= "{ifname}: {ipaddr}/{cidr} ";
		"format-linked"= "{ifname} (No IP) ";
		"format-disconnected"= "⚠  Disconnected";
		"tooltip-format"= "{ifname}: {ipaddr}";
		"on-click"= "rofi-wifi";
	};
	"hyprland/window"= {
		"format"= "{}";
	};
	"bluetooth"= {
		"format-on"= "";
		"format-off"= "󰂲";
		"format-connected"= "󰂱 {num_connections}";
		"on-click"= "rofi-bluetooth";
	};
	"mpd"={
		"format"= "{stateIcon} {consumeIcon}{randomIcon}{repeatIcon}{singleIcon}: Playing [{title}]";
		"format-stopped"= "{consumeIcon}{randomIcon}{repeatIcon}{singleIcon}🎧 No Song";
		"on-click"= "kitty --class mkitty ncmpcpp";
		"random-icons"= {
			"on"= " ";
		};
		"repeat-icons"= {
			"on"= " ";
		};
		"single-icons"= {
			"on"= "1";
		};
		"state-icons"= {
			"paused"= "";
			"playing"= "";
		};
	};
	"custom/weather"= {
		"format"= "{} °";
		"tooltip"= true;
		"interval"= 3600;
		"exec"= "${pkgs.wttrbar}/bin/wttrbar --fahrenheit --main-indicator 'temp_F'";
		"return-type"= "json";
	};
	"hyprland/workspaces"= {
		"disable-scroll"= true;
		"all-outputs"= false;
		"format"= "{icon}";
		"persistent_workspaces"= {
			"1"=["DP-1"];
			"2"=["DP-1"];
			"3"=["DP-1"];
			"4"=["DP-2"];
			"5"=["DP-2"];
			"6"=["DP-2"];
		};
		"format-icons"= {
			"1"= "一";
			"2"= "二";
			"3"= "三";
			"4"= "四";
			"5"= "五";
			"6"= "六";
		};
	};
	"cpu"= {
		"interval"= 10;
		"format"= " {}%";
		"max-length"= 10;
		"on-click"= "";
	};
	"memory"= {
		"interval"= 30;
		"format"= " {}%";
		"format-alt"=" {used:0.1f}G";
		"max-length"= 10;
	};
	"tray"= {
		"icon-size"= 13;
		"tooltip"= false;
		"spacing"= 10;
	};
	"clock"= {
		"format"= "{: %R   %d/%m}";
		"tooltip-format"= "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
	};
	"pulseaudio"= {
		"format"= "{icon} {volume}%";
		"tooltip"= false;
		"on-click"= "pavucontrol";
		"format-muted"= " Muted";
		"format-icons"= {
			"headphone"= "";
			"hands-free"= "";
			"headset"= "";
			"phone"= "";
			"portable"= "";
			"car"= "";
			"default"= ["" "" ""];
		};
	};
}]
