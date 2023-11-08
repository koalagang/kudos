{ config, pkgs, ... }:

# This file consists of my zsh configuration,
# as well as other tools I've got integrated into zsh
# i.e. starship, zoxide and fzf

# See https://thevaluable.dev/zsh-install-configure-mouseless/
# and https://thevaluable.dev/zsh-completion-guide-examples/
# to learn how the contents of completionInit and initExtra below work.

{
  # If there ever was a shell I'd hide under, it's the trusty Z shell
  programs.zsh = {
    enable = true;

    # where to store the zshrc and zshenv
    # can't use ${config.xdg.configHome}/zsh because then it does /home/user//home/user/.config/zsh
    # as the dotDir option is relative to the user's home directory
    dotDir = ".config/zsh";

    # Allow entering directories by entering path into shell (without need for 'cd' command)
    # For example, `Documents/neorg` would be equivalent to `cd Documents/neorg`
    autocd = true;

    # -- Completion
    enableCompletion = true;
    completionInit = ''
      # Basic tab completion
      autoload -U compinit && compinit -u # load the compinit function
      zstyle ':completion:*' menu select
      _comp_options+=(globdots) # include hidden files

      # Auto completion with case insensitivity
      zstyle ':completion:*' matcher-list "" 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
    '';

    # -- History
    history = {
      extended = true; # save timestamps into the history file
      ignorePatterns = [ # do not add these very dangerous commands to the history
        "rm *"
        "rm -rf *"
        "pkill *"
      ];
      ignoreSpace = true; # do not save commands beginning with a space
      path = "${config.xdg.dataHome}/zsh/zsh_history";
      # save 10,000 lines (this is actually the default behaviour)
      save = 10000;
      size = 10000;
      # share command history between zsh sessions
      share = true;
    };

    # -- Plugins
    enableAutosuggestions = true;
    syntaxHighlighting = {
      enable = true;
      # TODO: nix-colors
      #styles = {};
    };
    plugins = [
      {
        # allows for using my zsh config inside the nix ephemeral shell
        name = "zsh-nix-shell";
        file = "nix-shell.plugin.zsh";
        src = pkgs.fetchFromGitHub {
          owner = "chisui";
          repo = "zsh-nix-shell";
          rev = "v0.7.0";
          sha256 = "149zh2rm59blr2q458a5irkfh82y3dwdich60s9670kl3cl5h2m1";
        };
      }
    ];

    # -- vi mode
    defaultKeymap = "viins"; # start zsh in vi insert mode
    initExtra = ''
      # Load complist module to allow rebinding menu keys
      zmodload zsh/complist

      # enter zsh's vi normal mode with escape
      bindkey '^[' vi-cmd-mode
      export KEYTIMEOUT=1

      # edit line in vim buffer with ctrl+v when in zsh's vi normal mode
      autoload -U edit-command-line && zle -N edit-command-line && bindkey -M vicmd '^v' edit-command-line

      # use vi keys in tab complete menu
      bindkey -M menuselect 'h' vi-backward-char
      bindkey -M menuselect 'j' vi-down-line-or-history
      bindkey -M menuselect 'k' vi-up-line-or-history
      bindkey -M menuselect 'l' vi-forward-char
      bindkey '^?' backward-delete-char # fix backspace bug when switching modes

      # open vim with ctrl+v in zsh's vi insert mode
      bindkey -s '^v' 'vi^M'

      # -- fzf
      # Fixes issue where I can't use fzf's cd widget (left alt + c doesn't give any input)
      # This weird letter is basically just right-alt (sometimes called AltGr) + c
      # I use the British keyboard layout on a classic ThinkPad keyboard if that is of relevance
      bindkey '¢' fzf-cd-widget

      # search zoxide database using fzf and enter the selected path
      # 'bindkey -s' types out the full command before entering it, so using an alias makes it faster
      alias Z='cd "$(${pkgs.zoxide}/bin/zoxide query --interactive)"'
      bindkey -s '^z' 'Z^M' # ctrl+z
      # See programs.fzf further down for fzf config

      # -- suffix aliases
      # Like autocd but for files.
      # Any of the following formats can be opened in the respective software just by entering the filepath
      # (no need for prefixing it with vim or anything else).
      # This is particularly useful with the ctrl+t fzf widget
      # because it allows you to simply search for the file with fzf and then hit enter twice to open it.

      # programming
      alias -s lua="$EDITOR"      # lua
      alias -s nix="$EDITOR"      # nix
      alias -s rs="$EDITOR"       # rust
      alias -s sh="$EDITOR"       # shell
      alias -s gd="$EDITOR"       # gdscript

      # documents
      alias -s md="$EDITOR"       # markdown
      alias -s norg="$EDITOR"     # neorg
      alias -s tex="$EDITOR"      # latex
      alias -s txt="$EDITOR"      # regular, uninterpreted text
      # NOTE: I'm not sure how to handle libreoffice declaratively here
      # because it's not located in ${pkgs.libreoffice}/bin/libreoffice
      alias -s docx="libreoffice" # office document
      alias -s xlsx="libreoffice" # spreadsheet

      # media
      # you probably want to have window swallowing enabled in your WM/compositor for the following
      # alternatively, prefix them with setsid or with devour (latter only works on X)
      # video and audio files
      alias -s mp4="mpv"
      alias -s mkv="mpv"
      alias -s webm="mpv"
      alias -s mp3="mpv"
      alias -s flac="mpv"

      # image files
      # swiv is a wayland port of sxiv
      alias -s png="swiv || sxiv"
      alias -s jpg="swiv || sxiv"
      alias -s jpeg="swiv || sxiv"
      alias -s webp="swiv || sxiv"
      # I've included these in initExtra because I don't believe homemanager has an option for suffix aliases.
      # It only has global aliases and regular aliases.
    '';
  };

  # The general-purpose commandline fuzzy finder
  # It's so cute and fuzzy
  programs.fzf = {
    enable = true;
    enableZshIntegration = true;

    # TODO: stylix
    #colors = {};

    # -- fzf shell widgets
    # [right]alt + c = search with fzf and cd into output
    # ctrl + r = search history and paste output onto the commandline
    # ctrl + t = search for files and paste output onto the commandline
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
    #fileWidgetOptions = [
      #"--preview 'head {}'"
      # TODO: write a previewer script
      # this could use glow, bat, ueberzugpp, etc.
      # see https://github.com/jstkdng/ueberzugpp/blob/master/scripts/fzfub
      # and https://github.com/thimc/vifmimg for ideas on how to preview images
    #];

    #historyWidgetOptions = {}

    # NOTE: although not exactly an fzf widget,
    # I also have a binding for live grepping files with a different fuzzy finder.
    # See programs/neovim/default.nix if you're interested in that.
  };

  # My favourite shell prompt
  # I wouldn't leave Earth without it
  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    settings.line_break.disabled = true;
  };

  # A smarter cd command
  # Catching Zs
  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
  };
  # zoxide configuration
  home.sessionVariables = {
    _ZO_DATA_DIR = "${config.xdg.dataHome}/zsh";
    _ZO_MAXAGE = 10000;
    _ZO_RESOLVE_SYMLINKS = 1;
    _ZO_EXCLUDE_DIRS = "$HOME/.*:$XDG_DOCUMENTS_HOME/archive/*:/nix/store/*";
  };
}
