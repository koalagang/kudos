{ pkgs, config, ... }:
{
  home = {
    file."${config.xdg.configHome}/ytfzf/conf.sh".text = ''
      external_menu(){
        # NOTE: do not use the -H (height) or --fn (font size) flags because it messes up formatting
        ${pkgs.bemenu}/bin/bemenu --fb '#${config.colorScheme.palette.base00}' --ff '#${config.colorScheme.palette.base05}' --nb '#${config.colorScheme.palette.base00}' --nf '#${config.colorScheme.palette.base05}' --tb '#${config.colorScheme.palette.base00}' --hb '#${config.colorScheme.palette.base00}' --tf '#${config.colorScheme.palette.base0E}' --hf '#${config.colorScheme.palette.base0B}' --af '#${config.colorScheme.palette.base05}' --ab '#${config.colorScheme.palette.base00}' --bdr '#${config.colorScheme.palette.base0E}' -B 2 -R 10 -f -l30 -i -p 'YouTube'
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
