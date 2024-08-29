{ pkgs, config, ... }:

# menu script for copying, saving and editing screenshots in selected areas or of the full desktop
# plus recording selected areas or the full desktop
# **only works on Wayland**

{
  home = {
    packages = [
      (pkgs.writeShellScriptBin "screenmenu" ''
      # TODO: make escape button cancel commands
      # TODO: fix bugs
      # TODO: swap from wf-recorder to wl-screenrec (if you can figure out how to get it to work)
      # TODO: make screenshots get saved as YYYY-MM-DD
      screenshot_selected(){
          # ${pkgs.grim}/bin/grim -t png -g "$(${pkgs.slurp}/bin/slurp -c 00000000)"

          ${pkgs.wayshot}/bin/wayshot -s "$(${pkgs.slurp}/bin/slurp -c 00000000)" \
          -f "${config.xdg.userDirs.pictures}/screenshots/$(${pkgs.coreutils}/bin/date '+%F_%T' | ${pkgs.coreutils}/bin/tr ':' '-').png"

          ${pkgs.libnotify}/bin/notify-send 'Screenshot' 'Selected area saved!'
      }

      screenshot_full(){
          ${pkgs.wayshot}/bin/wayshot \
          -f "${config.xdg.userDirs.pictures}/screenshots/$(${pkgs.coreutils}/bin/date '+%F_%T' | ${pkgs.coreutils}/bin/tr ':' '-').png"

          ${pkgs.libnotify}/bin/notify-send 'Screenshot' 'Full desktop saved!'
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

      case "$(${pkgs.coreutils}/bin/printf '%s' "$selections" | ${config.home.sessionVariables.DMENU_CMD}
      ${config.home.sessionVariables.DMENU_EXTRA_FLAGS} -l 9 -p ''')" in
          'copy selected area') screenshot_selected --stdout | ${pkgs.wl-clipboard}/bin/wl-copy ;;
          'save selected area') screenshot_selected ;;
          'edit selected area') screenshot_selected  --stdout | ${pkgs.swappy}/bin/swappy -f - ;;
          'record selected area') record -g "$(${pkgs.slurp}/bin/slurp)" ;;
          # it's necessary to sleep briefly so that the menu isn't captured
          'copy full desktop') sleep 0.25 && screenshot_full --stdout | ${pkgs.wl-clipboard}/bin/wl-copy ;;
          'save full desktop') sleep 0.25 && screenshot_full ;;
          'edit full desktop') sleep 0.25 && screenshot_full  --stdout | ${pkgs.swappy}/bin/swappy -f - ;;
          'record full desktop') sleep 0.25 && record ;;
          'stop recording') ${pkgs.killall}/bin/killall ${pkgs.wf-recorder}/bin/wf-recorder
          # TODO: make record options not appear if already recording
          # and 'stop recording' option only appear when recording
      esac
      '')
    ];
  };
}
