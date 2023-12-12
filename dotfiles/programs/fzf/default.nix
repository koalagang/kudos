{ pkgs, ... }:

{
  programs.fzf = {
    enable = true;

    # Enable fzf widgets for any shell installed and configured by home-manager
    enableBashIntegration    = true;
    enableFishIntegration    = true;
    enableZshIntegration     = true;
    # NOTE: fzf does not have nushell integration

    # TODO: stylix
    #colors = {};

    /* -- fzf shell widgets
    alt + c = search with fzf and cd into output
    ctrl + r = search history and paste output onto the commandline
    ctrl + t = search for files and paste output onto the commandline
    */
    # use fd instead of find (much faster)
    changeDirWidgetCommand = "${pkgs.fd}/bin/fd --type d";

    changeDirWidgetOptions = [
      # preview file tree when using cd widget
      # {} = directory being previewed
      "--preview '${pkgs.tree}/bin/tree -C {} | head -200'"
      # I usually use 'eza --tree' instead of tree but it doesn't seem to work in this case
    ];

    defaultCommand = "${pkgs.fd}/bin/fd --type f";
    #defaultOptions = {};

    fileWidgetCommand = "${pkgs.fd}/bin/fd --type f";
    /*fileWidgetOptions = [
      "--preview 'head {}'"
      # TODO: write a previewer script
      # this could use glow, bat, ueberzugpp, etc.
      # see https://github.com/jstkdng/ueberzugpp/blob/master/scripts/fzfub
      # and https://github.com/thimc/vifmimg for ideas on how to preview images
    ]; */

    #historyWidgetOptions = {}
  };
}
