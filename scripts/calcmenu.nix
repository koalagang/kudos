{ pkgs, config, ... }:

{
  home = {
    packages = [
      (pkgs.writeShellScriptBin "calcmenu" ''
        equation="$(: | ${config.home.sessionVariables.DMENU_CMD} -p 'Enter equation ')"
        ${pkgs.libnotify}/bin/notify-send 'Result' -- "$(($equation))"
      '')
    ];
  };
}
