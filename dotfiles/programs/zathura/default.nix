{ config, pkgs, ... }:

{
  programs.zathura = {
    enable = true;

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

    options = {
      # whether or not to enable theme
      # hit 'i' or run `set recolor false` to disable on the fly
      recolor = true;

      # TODO: nix-colors
      default-fg = "#${config.colorScheme.palette.base05}";
      default-bg = "#${config.colorScheme.palette.base01}";
      completion-bg = "#${config.colorScheme.palette.base02}";
      completion-fg = "#${config.colorScheme.palette.base05}";
      completion-highlight-bg = "#${config.colorScheme.palette.base04}";
      completion-highlight-fg = "#${config.colorScheme.palette.base05}";
      completion-group-bg = "#${config.colorScheme.palette.base02}";
      completion-group-fg = "#${config.colorScheme.palette.base0D}";
      statusbar-fg = "#${config.colorScheme.palette.base05}";
      statusbar-bg = "#${config.colorScheme.palette.base02}";
      notification-bg = "#${config.colorScheme.palette.base02}";
      notification-fg = "#${config.colorScheme.palette.base05}";
      notification-error-bg = "#${config.colorScheme.palette.base02}";
      notification-error-fg = "#${config.colorScheme.palette.base08}";
      notification-warning-bg = "#${config.colorScheme.palette.base02}";
      notification-warning-fg = "#${config.colorScheme.palette.base0A}";
      inputbar-fg = "#${config.colorScheme.palette.base05}";
      inputbar-bg = "#${config.colorScheme.palette.base02}";
      recolor-lightcolor = "#${config.colorScheme.palette.base00}";
      # recolor-darkcolor = text colour
      # -- strictly following base16, this should be base05 but I use base06 just to make it look slightly more interesting
      recolor-darkcolor = "#${config.colorScheme.palette.base06}";
      index-fg = "#${config.colorScheme.palette.base05}";
      index-bg = "#${config.colorScheme.palette.base00}";
      index-active-fg = "#${config.colorScheme.palette.base05}";
      index-active-bg = "#${config.colorScheme.palette.base02}";
      render-loading-bg = "#${config.colorScheme.palette.base00}";
      render-loading-fg = "#${config.colorScheme.palette.base05}";
      highlight-color = "rgba(203, 166, 247, 0.5)";
      highlight-fg = "rgba(245,194,231,0.5)";
      highlight-active-color = "rgba(245,194,231,0.5)";
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
