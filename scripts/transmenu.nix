{ pkgs, config, ... }:

# TODO: make this work

{
  home = {
    packages = [
      (pkgs.writeShellScriptBin "transmenu" ''
        # Type `trans -S` into the terminal to see available engines
        # (though, in my experience, only google works).
        engine='google'

        input(){
          phrase="$(: | ${config.home.sessionVariables.DMENU_CMD} -p 'Enter phrase: ')"
        }
        clipboard(){
          phrase="$(${config.home.sessionVariables.PASTE_CMD})"
        }
        lang(){
          code="$(${config.home.sessionVariables.DMENU_CMD} -i -p 'Enter language code: ')"
        }

        case "$(${pkgs.coreutils}/bin/printf \
          'from input (lang -> en)\nfrom clipboard (lang -> en)\nfrom input (en -> lang)\nfrom clipboard (en -> lang)' |
          ${config.home.sessionVariables.DMENU_CMD} -i -l 4 -p 'Translate:')" in
            'from input (lang -> en)') input ;;
            'from clipboard (lang -> en)') clipboard ;;
            'from input (en -> lang)') lang && input ;;
            'from clipboard (en -> lang)') lang && clipboard ;;
        esac

        # exit if no input is given
        [ -z "$phrase" ] && exit 0

        [ -n "$code" ] && EXTRA_ARG="en=$code"
        ${pkgs.libnotify}/bin/notify-send 'Translation' \
          "$(${pkgs.translate-shell}/bin/trans $EXTRA_ARG -b "$phrase" -engine "$engine")"
      '')
    ];
  };
}
