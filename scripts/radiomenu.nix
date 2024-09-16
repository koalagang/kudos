{ pkgs, config, ... }:

# TODO: playerctl doesn't seem to work. Fix it.

# Listen to the radio using dmenu and mpv. No need for an API or some bloated application like a web browser. ;)
# To find the URL you need for your chosen radio, inspect element on the play button on the website and then press it.
# This should point you to the URL (at least that's how it works for Chromium-based browsers). Easy as pie.
# Some websites force you into creating an account to listen
# but if you can get the URL another way then you can listen without an account.
# If, for example, you wanted to listen to BBC radio without creating an account, you could use URLs shown on this page:
# https://gist.githubusercontent.com/bpsib/67089b959e4fa898af69fea59ad74bc3/raw/66afe675421d912a4461d3d86abe1b30b1d041fa/BBC-Radio.m3u
# You can also play music from Soundcloud by using the 'share' URL; this can actually also be used to bypass premium songs.

{
  home = {
    packages = [
      (pkgs.writeShellScriptBin "radiomenu" ''
        change_radio (){
          ${pkgs.procps}/bin/pkill --full 'mpv-radiomenu'
          [ -n "$1" ] && ${pkgs.mpv}/bin/mpv --title='mpv-radiomenu' --volume='45' "$1" &
        }

        # Open menu
        case "$(printf 'K-pop\nJ-pop\nClassical\nCurrently playing song\nStop radio' | ${config.home.sessionVariables.DMENU_CMD} ${config.home.sessionVariables.DMENU_EXTRA_FLAGS} -i -l5 -p 'Radio')" in
            'K-pop') change_radio 'https://listen.moe/kpop/stream' ;;
            'J-pop') change_radio 'https://listen.moe/stream' ;;
            'Classical') change_radio 'https://live.musopen.org:8085/streamvbr0?' ;;
            'Currently playing song')
              ${pkgs.playerctl}/bin/playerctl -ps mpv.instance"''$(${pkgs.procps}/bin/pgrep --full mpv-radiomenu)" metadata &&
                uses_pid=1
              if [ -z "$uses_pid" ]; then
                  player='mpv'
              else
                  player="mpv.instance$(${pkgs.procps}/bin/pgrep --full mpv-radiomenu)"
              fi
              ${pkgs.coreutils}/bin/echo "$(${pkgs.playerctl}/bin/playerctl -p "$player" metadata artist) - $(${pkgs.playerctl}/bin/playerctl -p "$player" metadata title)" |
               ${config.home.sessionVariables.COPY_CMD}

              # BUG: playerctl can't read metadata -> No players found (issue with mpris?)
              ${pkgs.libnotify}/bin/notify-send -t 10000 'Artist' "$(${pkgs.playerctl}/bin/playerctl -p "$player" metadata artist)"
              ${pkgs.libnotify}/bin/notify-send -t 10000 'Song' "$(${pkgs.playerctl}/bin/playerctl -p "$player" metadata title)"
              ${pkgs.libnotify}/bin/notify-send -t 10000 'Album' "$(${pkgs.playerctl}/bin/playerctl -p "$player" metadata album)" ;;
            'Stop radio') ${pkgs.procps}/bin/pkill --full 'mpv-radiomenu'
      esac
      '')
    ];
  };
}
