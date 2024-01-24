{ pkgs, ... }:

# I may consider moving these to my scripts directory

{
  home.packages = [
    # Extract an archive (compressed files/folders)
    (pkgs.writeShellScriptBin "ex" ''
      if [ -f "$1" ] ; then
          case "$1" in
              # unlikely that I'll need these
              #*.7z)        7z x "$1"       ;;
              #*.deb)       ar x "$1"       ;;
              #*.tar.zst)   unzstd "$1"     ;;
              #*.rar)       unrar x "$1"    ;; # unrar is unfree
              *.Z)         ${pkgs.gzip}/bin/uncompress "$1"     ;;
              *.bz2)       ${pkgs.bzip2}/bin/bunzip2 "$1" ;;
              *.gz)        ${pkgs.gzip}/bin/gunzip "$1"         ;;
              *.tar)       ${pkgs.gnutar}/bin/tar xf "$1"       ;;
              *.tar.bz2)   ${pkgs.gnutar}/bin/tar xjf "$1"      ;;
              *.tar.gz)    ${pkgs.gnutar}/bin/tar xf "$1"       ;;
              *.tar.xz)    ${pkgs.gnutar}/bin/tar xf "$1"       ;;
              *.tbz2)      ${pkgs.gnutar}/bin/tar xjf "$1"      ;;
              *.tgz)       ${pkgs.gnutar}/bin/tar xzf "$1"      ;;
              *.zip)       ${pkgs.unzip}/bin/unzip "$1"         ;;
              *)           ${pkgs.coreutils}/bin/echo "'$1' cannot be extracted with ex"
          esac
      else
          ${pkgs.coreutils}/bin/echo "error: '$1' is not a valid file"
      fi
    '')

    # Compress a folder or a file
    (pkgs.writeShellScriptBin "comp" ''
      case "$2" in
          '-t')   ${pkgs.gnutar}/bin/tar -c --auto-compress -f "$1.tar.gz" "$1" ;;
          '-z')   ${pkgs.gnutar}/bin/tar -c --auto-compress -f "$1.zip" "$1" ;;
          *)      ${pkgs.gnutar}/bin/tar -c --auto-compress -f "$1.tar.gz" "$1"
      esac
    '')

    # Backup a file
    (pkgs.writeShellScriptBin "bak" ''
      ${pkgs.coreutils}/bin/cp --backup=numbered "$1" "$1.bak"
    '')

    # Upload content to 0x0.st (a pastebin and URL shortener)
    (pkgs.writeShellScriptBin "oxo" ''
      while getopts 's:f:u:' OPT; do
        case $OPT in
          s) ${pkgs.curl}/bin/curl -F "shorten=$OPTARG" http://0x0.st ;;
          f) ${pkgs.curl}/bin/curl -F "file=@$OPTARG" http://0x0.st   ;;
          u) ${pkgs.curl}/bin/curl -F "url=$OPTARG" http://0x0.st     ;;
          *) ${pkgs.coreutils}/bin/echo 'error: invalid flag' # for some reason it won't get invoked
        esac
      done
    '')

    (pkgs.writeShellScriptBin "hm" ''
      while getopts 'h:m:' OPT; do
        case $OPT in
          # take a number of minutes as input and output it in hours and minutes, e.g.
          # $ hm -h 152
          # 2 hours + 32 minutes
          h) ${pkgs.units}/bin/units "$OPTARG"mins 'hours;minutes' ;;
          # same as above but seconds -> mins+secs
          m) ${pkgs.units}/bin/units "$OPTARG"secs 'minutes;seconds' ;;
          *) ${pkgs.coreutils}/bin/echo 'error: invalid flag'
        esac
      done
    '')
  ];
}
