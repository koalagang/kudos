{ pkgs, config, ... }:

{
  home = {

    # one of these must be commented
    sessionVariables = {
      # X11
      #COLOUR_CMD = ''
      #  ${pkgs.colorpicker}/bin/colorpicker --short --one-shot --preview |
      #  ${pkgs.coreutils}/bin/tr -d '\n' | ${pkgs.xclip}/bin/xclip -selection clipboard
      #'';
      # Wayland
      COLOUR_CMD = "${pkgs.hyprpicker}/bin/hyprpicker --autocopy";
    };

    packages = [
      (pkgs.writeShellScriptBin "colourmenu" ''
      case "$(${pkgs.coreutils}/bin/printf 'custom\nblack\nred\ngreen\nyellow\nblue\nmagenta\ncyan\nwhite' |
        ${config.home.sessionVariables.DMENU_CMD} -i -p 'Pick a colour')" in
          'custom') ${config.home.sessionVariables.COLOUR_CMD} &&
            ${pkgs.libnotify}/bin/notify-send 'colourmenu' 'Copied custom hex to clipboard!' ;;
          'black') ${pkgs.coreutils}/bin/printf '#000000' |
            ${config.home.sessionVariables.COPY_CMD} &&
            ${pkgs.libnotify}/bin/notify-send 'colourmenu' 'Copied black hex to clipboard!'   ;;
          'red') ${pkgs.coreutils}/bin/printf '#FF0000' |
            ${config.home.sessionVariables.COPY_CMD} &&
            ${pkgs.libnotify}/bin/notify-send 'colourmenu' 'Copied red hex to clipboard!'     ;;
          'green') ${pkgs.coreutils}/bin/printf '#00FF00' |
            ${config.home.sessionVariables.COPY_CMD} &&
            ${pkgs.libnotify}/bin/notify-send 'colourmenu' 'Copied green hex to clipboard!'   ;;
          'yellow') ${pkgs.coreutils}/bin/printf '#FFFF00' |
            ${config.home.sessionVariables.COPY_CMD} &&
            ${pkgs.libnotify}/bin/notify-send 'colourmenu' 'Copied yellow hex to clipboard!'  ;;
          'blue') ${pkgs.coreutils}/bin/printf '#0000FF' |
            ${config.home.sessionVariables.COPY_CMD} &&
            ${pkgs.libnotify}/bin/notify-send 'colourmenu' 'Copied blue hex to clipboard!'    ;;
          'magenta') ${pkgs.coreutils}/bin/printf '#FF00FF' |
            ${config.home.sessionVariables.COPY_CMD} &&
            ${pkgs.libnotify}/bin/notify-send 'colourmenu' 'Copied magenta hex to clipboard!' ;;
          'cyan') ${pkgs.coreutils}/bin/printf '#00FFFF' |
            ${config.home.sessionVariables.COPY_CMD} &&
            ${pkgs.libnotify}/bin/notify-send 'colourmenu' 'Copied cyan hex to clipboard!'    ;;
          'white') ${pkgs.coreutils}/bin/printf '#FFFFFF' |
            ${config.home.sessionVariables.COPY_CMD} &&
            ${pkgs.libnotify}/bin/notify-send 'colourmenu' 'Copied white hex to clipboard!'
      esac
      '')
    ];
  };
}
