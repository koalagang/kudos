{ pkgs, config, ... }:

# menu script which adds support copying, saving and editing screenshots in selected areas or of the full desktop
# plus recording selected areas or the full desktop
# **only works on Wayland**

{
  home = {
    packages = [
      (pkgs.writeShellScriptBin "screenmenu" ''
      screenshot_selected(){
          ${pkgs.grim}/bin/grim -t png -g "$(${pkgs.slurp}/bin/slurp -c 00000000)"
      }

      screenshot_full(){
          ${pkgs.grim}/bin/grim -t png \
          "${config.xdg.userDirs.pictures}/$(${pkgs.coreutils}/bin/date '+%F_%T' | tr ':' '-').png"
      }

      record(){
          ${pkgs.wf-recorder}/bin/wf-recorder -f \
          "${config.xdg.userDirs.videos}/$(${pkgs.coreutils}/bin/date '+%F_%T' | tr ':' '-').mp4"
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

      # script is slightly broken
      # TODO: fix it
      case "$(${pkgs.coreutils}/bin/printf '%s' "$selections" | ${config.home.sessionVariables.DMENU_CMD} -l 9)" in
          'copy selected area') screenshot_selected - | ${pkgs.wl-clipboard}/bin/wl-copy ;;
          'save selected area') screenshot_selected ;;
          'edit selected area') screenshot_selected  - | ${pkgs.swappy}/bin/swappy -f - ;;
          'record selected area') record -g "$(${pkgs.slurp}/bin/slurp)" ;;
          # it's necessary to sleep briefly so that the menu isn't captured
          'copy full desktop') sleep 0.25 && screenshot_full - | ${pkgs.wl-clipboard}/bin/wl-copy ;;
          'save full desktop') sleep 0.25 && screenshot_full ;;
          'edit full desktop') sleep 0.25 && screenshot_full  - | ${pkgs.swappy}/bin/swappy -f - ;;
          'record full desktop') sleep 0.25 && record ;;
          'stop recording') killall ${pkgs.wf-recorder}/bin/wf-recorder
      esac
      '')
    ];
  };
}
