{ pkgs, config, ... }:

# menu script for copying, saving and editing screenshots in selected areas or of the full desktop
# plus recording selected areas or the full desktop
# **only works on Wayland**

# TODO:
# Make notification say that screenshot failed if you hit escape (i.e. cancel slurp).
# I've already programmed in error-handling but it doesn't seem to work.
# TODO:
# Figure out why the quality of my screenshots is so poor.

{
  home.packages = [
    (pkgs.writeShellScriptBin "screenmenu" ''
      screenshots_dir="${config.xdg.userDirs.pictures}/screenshots"
      [ -d "$screenshots_dir" ] || mkdir -p "$screenshots_dir"

      # as there are a six different combinations, we stay DRY by programmatically constructing the command when we need to
      screenshot(){
        cmd="${pkgs.wayshot}/bin/wayshot"

        [[ "$1" == 'copy' || "$1" == 'edit' ]] && cmd="$cmd --stdout"

        if [[ "$2" == 'select' ]]; then
          cmd="$cmd -s '$(${pkgs.slurp}/bin/slurp -c 00000000)'"
          notification='Selected area'
        elif [[ "$2" == 'full' ]]; then
          notification='Full desktop'
        fi

        if [[ "$1" == 'copy' ]]; then
          cmd="$cmd | ${pkgs.wl-clipboard}/bin/wl-copy"
          notification="$notification copied!"
        elif [[ "$1" == 'edit' ]]; then
          cmd="$cmd | ${pkgs.swappy}/bin/swappy -f -"
        elif [[ "$1" == 'save' ]]; then
          cmd="$cmd -f "$screenshots_dir/$(${pkgs.coreutils}/bin/date '+%F_%T' | ${pkgs.coreutils}/bin/tr ':' '-').png""
          notification="$notification saved!"
        fi

        eval "$cmd" || error=1

        if [ -n "$error" ]; then
          ${pkgs.libnotify}/bin/notify-send 'Oops!' 'Screenshot failed'
        elif [ "$1" != 'edit' ]; then
          ${pkgs.libnotify}/bin/notify-send 'Screenshot' "$notification"
        fi
      }

      record(){
          ${pkgs.wf-recorder}/bin/wf-recorder \
          -f "${config.xdg.userDirs.videos}/$(${pkgs.coreutils}/bin/date '+%F_%T' | ${pkgs.coreutils}/bin/tr ':' '-').mp4"

          ${pkgs.libnotify}/bin/notify-send 'Recording' 'You are now recording a video!'
      }

      selections='copy selected area
      save selected area
      edit selected area
      record selected area
      copy full desktop
      save full desktop
      edit full desktop
      record full desktop
      stop recording'

      case "$(${pkgs.coreutils}/bin/printf '%s' "$selections" | ${config.home.sessionVariables.DMENU_CMD} ${config.home.sessionVariables.DMENU_EXTRA_FLAGS} -l 9 -p ''')" in
          'copy selected area') screenshot 'copy' 'select' ;;
          'save selected area') screenshot 'save' 'select' ;;
          'edit selected area') screenshot 'edit' 'select' ;;
          'record selected area') record -g "$(${pkgs.slurp}/bin/slurp)" ;;
          # it's necessary to sleep briefly so that the menu isn't captured
          'copy full desktop') sleep 0.25 && screenshot 'copy' 'full' ;;
          'save full desktop') sleep 0.25 && screenshot 'save' 'full' ;;
          'edit full desktop') sleep 0.25 && screenshot 'edit' 'full' ;;
          'record full desktop') sleep 0.25 && record ;;
          'stop recording') ${pkgs.killall}/bin/killall ${pkgs.wf-recorder}/bin/wf-recorder
          # TODO: make record options not appear if already recording
          # and 'stop recording' option only appear when recording
      esac
    '')
  ];
}
