{ pkgs, config, ... }:

{
  programs.fzf = {
    enable = true;

    enableBashIntegration = true;
    enableFishIntegration = true;
    enableZshIntegration  = true;

    colors = {
      "bg+" = "#${config.colorScheme.palette.base02}";
      bg = "#${config.colorScheme.palette.base00}";
      spinner = "#${config.colorScheme.palette.base0F}";
      hl = "#${config.colorScheme.palette.base08}";
      fg = "#${config.colorScheme.palette.base05}";
      header = "#${config.colorScheme.palette.base08}";
      info = "#${config.colorScheme.palette.base0E}";
      pointer = "#${config.colorScheme.palette.base0F}";
      marker = "#${config.colorScheme.palette.base07}";
      "fg+" = "#${config.colorScheme.palette.base05}";
      prompt = "#${config.colorScheme.palette.base0E}";
      "hl+" = "#${config.colorScheme.palette.base08}";
      selected-bg = "#${config.colorScheme.palette.base03}";
    };

    defaultCommand = "${pkgs.bfs}/bin/bfs -nohidden -type f";
    #defaultOptions = {};

    /* -- fzf shell widgets
    alt + c = search with fzf and cd into output
    ctrl + t = search for files and paste output onto the commandline
    ctrl + r = search history and paste output onto the commandline

    Note that I don't use the ctrl+r widget as I use McFly instead, which also uses the ctrl+r widget
    McFly with fzf integration enabled is basically a smarter fzf history widget
    See programs/mcfly for the config
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
  };
}
