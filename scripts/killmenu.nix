{ pkgs, config, ... }:

{
  home = {
    packages = [
      (pkgs.writeShellScriptBin "killmenu" ''
        process="$(${pkgs.procps}/bin/ps -u "$USER" -o pid,%mem,%cpu,comm |
          ${pkgs.coreutils}/bin/sort -b -k2 -r |
          ${pkgs.gnused}/bin/sed -n '1!p' |
          ${config.home.sessionVariables.DMENU_CMD} -i -l 20 |
          ${pkgs.gawk}/bin/gawk '{ print $1 }')"

        [ -z "$process" ] || choice="$(${pkgs.coreutils}/bin/printf 'Yes\nNo' |
          ${config.home.sessionVariables.DMENU_CMD} -i -p 'Kill process?')"
          case "$choice" in
              'Yes') ${pkgs.coreutils}/bin/kill -15 "$process" ;; # SIGTERM
              'No') exit 0
          esac
      '')
    ];
  };
}
