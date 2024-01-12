{ pkgs, config, ... }:

{
  home = {
    packages = [
      (pkgs.writeShellScriptBin "calcmenu" ''
        # take user input using menu program of choice
        # the colon here is just because some menus expect an input
        # so we're simply giving it an empty input
        equation="$(: | ${config.home.sessionVariables.DMENU_CMD} -p 'Enter equation ')"

        # use bc for the calculation and then round the number to two decimal places using printf
        # finally, notify the user of the result
        ${pkgs.libnotify}/bin/notify-send \
          'Result' -- "$(${pkgs.coreutils}/bin/printf %.2f \
          $(${pkgs.coreutils}/bin/echo "$equation" | ${pkgs.bc}/bin/bc -l))"

        # it's important to note that, although bash itself can make calculations,
        # it can't handle decimal places (hence why we're using bc)
      '')
    ];
  };
}
