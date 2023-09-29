{ pkgs, ... }:

{
  programs.zathura = {
    enable = true;

    # TODO: stylix

    options = {
      # enable clipboard
      selection-clipboard = "clipboard";
      # disable notification which displays when copying
      selection-notification = false;
      # disable the statusbar by default
      guioptions = "";
      page-padding = 6;
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

    shellAliases = { za = "zathura"; };
  };
}
