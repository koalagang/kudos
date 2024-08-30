{ pkgs, config, ... }:
{
  home = {
    # TODO: nix-colors
    file."${config.xdg.configHome}/ytfzf/conf.sh".text = ''
      external_menu(){
        # NOTE: do not use the -H (height) or --fn (font size) flags because it messes up formatting
        bemenu --fb '#1e1e2e' --ff '#cdd6f4' --nb '#1e1e2e' --nf '#cdd6f4' --tb '#1e1e2e' --hb '#1e1e2e' --tf '#f38ba8' --hf '#f9e2af' --af '#cdd6f4' --ab '#1e1e2e' --bdr '#f38ba8' -B 2 -R 10 -f -l30 -i -p 'YouTube'
      }
    '';

    packages = [
      (pkgs.writeShellScriptBin "ytmenu" ''
        yt_command='${pkgs.ytfzf}/bin/ytfzf --notify-playing -D'

          case "$(printf 'Search and play\nSearch and download\nFind link through search\nPlay from history\nFind link in history\nClear history' | ${config.home.sessionVariables.DMENU_CMD} -i -l 7 -p 'YouTube')" in
              'Search and play') eval $yt_command ;;
              'Search and download') eval $yt_command -d && ${pkgs.libnotify}/bin/notify-send 'ytmenu' 'Download complete!' ;;
              # Useful for if you want to share a video or if you want to check the description
              'Find link through search') eval $yt_command -L | ${config.home.sessionVariables.COPY_CMD} && ${pkgs.libnotify}/bin/notify-send 'ytmenu' 'Copied link to clipboard!' ;;
              'Find link in history') eval $yt_command -LH | ${config.home.sessionVariables.COPY_CMD} && ${pkgs.libnotify}/bin/notify-send 'ytmenu' 'Copied link to clipboard!' ;;
              'Play from history') eval $yt_command -H || ${pkgs.libnotify}/bin/notify-send 'ytmenu' 'History is empty!' ;;
              'Clear history') ${pkgs.ytfzf}/bin/ytfzf -x && ${pkgs.libnotify}/bin/notify-send 'ytmenu' 'History has been cleared!' ;;
          esac
      '')
    ];
  };
}
