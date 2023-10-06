{
  pkgs,
  config,
  lib,
  ...
}: let
  inherit (lib) mkEnableOption mkIf mkOption types;
  cfg = config.rice;
in {
  options.rice.mpd = {
    enable = mkOption {
      type = types.bool;
      default = cfg.enable;
    };
    path = mkOption {
      type = types.str;
      default = "~/Music";
      description = "Music Directory";
    };
  };
  config = mkIf cfg.mpd.enable {
    services.mpd = {
      enable = true;
      musicDirectory = cfg.mpd.path;
      extraConfig = ''
        audio_output {
          type "pipewire"
          name "Pipewire"
        }
        audio_output {
          type "fifo"
          name "Visualizer"
          path "/tmp/mpd.fifo"
          format "44100:16:2"
        }
      '';
    };
    programs.ncmpcpp = {
      enable = true;
      package = pkgs.ncmpcpp.override {visualizerSupport = true;};
      bindings = [
        {
          key = "j";
          command = "scroll_down";
        }
        {
          key = "k";
          command = "scroll_up";
        }
        {
          key = "J";
          command = ["select_item" "scroll_down"];
        }
        {
          key = "K";
          command = ["select_item" "scroll_up"];
        }
      ];
      settings = {
        execute_on_song_change = ''notify-send "Playing" "$(${pkgs.mpc}/bin/mpc --format '%title% - %album%' current)"'';
        visualizer_data_source = "/tmp/mpd.fifo";
        visualizer_output_name = "visualizer";
        visualizer_in_stereo = "yes";
        visualizer_type = "wave";
        visualizer_look = "+|";
      };
    };
  };
}
