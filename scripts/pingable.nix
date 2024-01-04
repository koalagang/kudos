{ pkgs, ... }:

# Check if you are able to establish a connection with a server (repeats until you do).
# This is nice to use if you're having internet connection issues
# and you want to receive a notification when you regain a connection.

{
  home = {
    packages = [
      (pkgs.writeShellScriptBin "pingable" ''
        [ -n "$1" ] && server="$1" || server='archlinux.org'

        while true; do
          ${pkgs.unixtools.ping}/bin/ping -q -c1 "$server" &&
            printf '\npingable: connection established!\n' &&
            ${pkgs.libnotify}/bin/notify-send 'pingable' 'connection established!' &&
            break
        done
      '')
    ];
  };
}
