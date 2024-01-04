{ pkgs, ... }:

{
  programs.fzf = {
    enable = true;

    # Enable fzf widgets for any shell installed and configured by home-manager
    enableBashIntegration = true;
    enableFishIntegration = true;
    enableZshIntegration  = true;
    # NOTE: fzf does not have nushell integration

    # TODO: stylix
    #colors = {};

    defaultCommand = "${pkgs.bfs}/bin/bfs -nohidden -type f";
    #defaultOptions = {};

    /* -- fzf shell widgets
    alt + c = search with fzf and cd into output
    ctrl + r = search history and paste output onto the commandline
    ctrl + t = search for files and paste output onto the commandline
    */

    # -- alt + c widget
    # use bfs instead of find or fd (much faster; so fast I never even see fzf's loading symbol)
    changeDirWidgetCommand = "${pkgs.bfs}/bin/bfs -nohidden -type d";
    changeDirWidgetOptions = [
      # preview file tree when using cd widget
      # {} = directory being previewed
      "--preview '${pkgs.tree}/bin/tree -C {} | head -200'"
      # I usually use 'eza --tree' instead of tree but it doesn't seem to work in this case
    ];

    # -- ctrl + t widget
    # This is particularly useful with zsh suffixes
    # because it allows you to simply search for the file with fzf and then hit enter twice to open it.
    # Another usecase is 'git add ' <ctrl+t> search for file <enter>.
    fileWidgetCommand = "${pkgs.bfs}/bin/bfs -nohidden -type f";
    /*fileWidgetOptions = [
      "--preview 'head {}'"
      # TODO: write a previewer script
      # this could use glow, bat, ueberzugpp, etc.
      # see https://github.com/jstkdng/ueberzugpp/blob/master/scripts/fzfub
      # and https://github.com/thimc/vifmimg for ideas on how to preview images
    ]; */

    # ctrl + r widget
    #historyWidgetOptions = {}
  };
}
