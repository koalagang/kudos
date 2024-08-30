{ pkgs, config, ... }:

# BUG: a lot of content gets cut off (e.g. 'Isolated Web Content' becomes 'Isolated Web Co')

{
  home = {
    packages = [
      (pkgs.writeShellScriptBin "killmenu" ''
        process="$(${pkgs.procps}/bin/ps -u "$USER" -o pid,comm |
          ${pkgs.coreutils}/bin/sort -b -k2 -r |
          ${pkgs.gnused}/bin/sed -n '1!p' |
          ${config.home.sessionVariables.DMENU_CMD} ${config.home.sessionVariables.DMENU_EXTRA_FLAGS} -i -l 20 -p 'Kill a running process' |
          ${pkgs.gawk}/bin/gawk '{ print $1 }')"

        [ -z "$process" ] || choice="$(${pkgs.coreutils}/bin/printf 'Yes\nNo' |
          ${config.home.sessionVariables.DMENU_CMD} -i -l2 -p 'Kill process?')"
          case "$choice" in
              'Yes') ${pkgs.coreutils}/bin/kill -15 "$process" ;; # SIGTERM
              'No') exit 0
          esac
      '')
    ];
  };
}
