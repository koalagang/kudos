{ pkgs, ... }:

{
  programs.zathura = {
    enable = true;

    # TODO: stylix

    options = {
      page-padding = 6; # number of pixels between pages
      selection-clipboard = "clipboard"; # copy selected text to clipboard
      selection-notification = false; # disable notification which displays when copying
      guioptions = ""; # disable the statusbar by default
      database = "null"; # don't keep history and bookmark files
    };

    mappings = {
      u = "scroll half-up";
      d = "scroll half-down";
      D = "toggle_page_mode";
      r = "reload";
      R = "rotate";
      H = "zoom in";
      L = "zoom out";
      M = "zoom 100%";
      i = "recolor";
      p = "print";
      S = "toggle_statusbar";
      # display how many words there are in the current pdf file
      # see my countwords script below for how it is done
      w = "exec \"countwords $FILE\"";
    };
  };

  home = {
    packages = [
      (pkgs.writeShellScriptBin "countwords" ''
      ${pkgs.libnotify}/bin/notify-send 'Word count' "$(${pkgs.poppler_utils}/bin/pdftotext $1 - | \
      ${pkgs.coreutils}/bin/tr -d '[:punct:]' | ${pkgs.coreutils}/bin/wc -w)"
    '')
    ];

    shellAliases.za = "zathura";
  };
}
