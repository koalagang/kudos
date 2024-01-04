{ config, pkgs, ... }:

# See https://thevaluable.dev/zsh-install-configure-mouseless/
# and https://thevaluable.dev/zsh-completion-guide-examples/
# to learn how the contents of completionInit and initExtra below work.

{
  # I have an fzf config elsewhere in the repo
  # but I'm specifying this here too because parts of my zsh config depend on fzf
  home.packages = [ pkgs.fzf ];

  programs.zsh = {
    enable = true;

    # where to store the zshrc and zshenv
    # can't use ${config.xdg.configHome}/zsh because then it does /home/user//home/user/.config/zsh
    # as the dotDir option is relative to the user's home directory
    # NOTE: homemanager will still place a .zshenv in the home directory,
    # which sources a second .zshenv located in the dotDir
    dotDir = ".config/zsh";

    # start zsh in vi insert mode
    defaultKeymap = "viins";

    # -- Easy cd'ing
    # Allow entering directories by entering path into shell (without need for 'cd' command)
    # For example, `Documents/neorg` would be equivalent to `cd Documents/neorg`
    # Works really well with dirHashes and cdpath
    autocd = true;
    # I go into these directories a lot
    # so it's nice to be able to cd into them from anywhere
    cdpath =  [
     "${config.xdg.userDirs.desktop}/git"
     "${config.xdg.userDirs.documents}/neorg"
     "${config.xdg.userDirs.videos}/immersion"
    ];
    # cd into directories just by typing 'cd ~<hash>'
    # e.g. 'cd ~v' will send you to Videos
    # the 'cd' can be dropped from the command if you have autocd enabled
    dirHashes = {
      de = "${config.xdg.userDirs.desktop}";
      dl = "${config.xdg.userDirs.download}";
      do = "${config.xdg.userDirs.documents}";
      g  = "${config.xdg.userDirs.desktop}/git";
      p  = "${config.xdg.userDirs.pictures}";
      v  = "${config.xdg.userDirs.videos}";
    };

    # -- Completion
    enableCompletion = true;
    completionInit = ''
      # Basic tab completion
      autoload -U compinit && compinit # load the compinit function
      zstyle ':completion:*' menu select
      _comp_options+=(globdots) # include hidden files

      # Auto-completion with case insensitivity
      zstyle ':completion:*' matcher-list "" 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
    '';

    # -- History
    history = {
      path = "${config.xdg.dataHome}/zsh/zsh_history";
      extended = true; # save timestamps into the history file
      # do not add these very dangerous commands to the history
      # this is very important if you use the fzf history widget
      ignorePatterns = [
        # kills all running processes
        "kill *"
        "killall *"
        "pkill *"

        # deletes all files and folders in the current directory
        "rm *"
        "rm -r *"
        "rm * -r"
        "rm * -f"
        "rm -f *"
        "rm -rf *"
        "rm * -rf"
        "bfs -rm *"
        "bfs * -rm"
        "bfs * -delete"
        "bfs -delete *"
        "find * -delete"
      ];
      # do not save commands beginning with a space
      # (useful for if you want to enter a command that you don't want in your history,
      # e.g. one containing a password)
      ignoreSpace = true;
      # save 10,000 lines
      save = 10000;
      size = 10000;
      # when the line limit is reached, begin deleting duplicates first
      expireDuplicatesFirst = true;
      # share command history between zsh sessions
      share = true;
    };

    # zsh settings neglected by the homemanager module
    # this includes bindings (bindkey), suffixes (alias -s) and some options (setopt)
    initExtra = ''
      # Load complist module to allow rebinding keys
      zmodload zsh/complist

      # -- vi and vim
      # enter zsh's vi normal mode with escape
      bindkey '^[' vi-cmd-mode
      export KEYTIMEOUT=1
      bindkey '^?' backward-delete-char # fix backspace bug when switching modes

      # edit line in vim buffer with ctrl+v when in zsh's vi normal mode
      autoload -U edit-command-line && zle -N edit-command-line && bindkey -M vicmd '^v' edit-command-line

      # open vim with ctrl+v in zsh's vi insert mode
      bindkey -s '^v' 'vi^M'

      # -- misc bindings
      # Fixes issue where I can't use fzf's cd widget (left alt + c doesn't give any input).
      # This weird letter is basically just right-alt (sometimes called AltGr) + c.
      # I use the British keyboard layout on a classic ThinkPad keyboard fwiw
      bindkey '¢' fzf-cd-widget

      # search zoxide database using fzf and enter the selected path with ctrl+f
      # 'bindkey -s' types out the full command before entering it, so using an alias makes it faster
      alias Z='cd "$(${pkgs.zoxide}/bin/zoxide query --interactive)"'
      bindkey -s '^f' 'Z^M'

      # quickly push an application (e.g. vim) into the background with ctrl+z
      # and then just as quickly pull it into the foreground again with ctrl+z
      bindkey -s '^z' 'fg^M'

      # -- suffix aliases
      # Like autocd but for files.
      # Any of the following formats can be opened in the respective software just by entering the filepath
      # (no need for prefixing it with vim or anything else).
      # This is particularly useful with the ctrl+t fzf widget
      # because it allows you to simply search for the file with fzf and then hit enter twice to open it.

      # programming
      alias -s lua="${config.home.sessionVariables.EDITOR}"  # lua
      alias -s nix="${config.home.sessionVariables.EDITOR}"  # nix
      alias -s rs ="${config.home.sessionVariables.EDITOR}"  # rust
      alias -s sh ="${config.home.sessionVariables.EDITOR}"  # shell
      alias -s gd ="${config.home.sessionVariables.EDITOR}"  # gdscript

      # documents
      alias -s md  ="${config.home.sessionVariables.EDITOR}" # markdown
      alias -s norg="${config.home.sessionVariables.EDITOR}" # neorg
      alias -s tex ="${config.home.sessionVariables.EDITOR}" # latex
      alias -s txt ="${config.home.sessionVariables.EDITOR}" # regular, uninterpreted text
      alias -s docx="${pkgs.libreoffice}/bin/swriter"        # office document
      alias -s xlsx="${pkgs.libreoffice}/bin/scalc"          # spreadsheet

      # video and audio files
      alias -s flac="${pkgs.mpv}/bin/mpv"
      alias -s mkv ="${pkgs.mpv}/bin/mpv"
      alias -s mp3 ="${pkgs.mpv}/bin/mpv"
      alias -s mp4 ="${pkgs.mpv}/bin/mpv"
      alias -s webm="${pkgs.mpv}/bin/mpv"

      # image files
      # swiv is a wayland port of sxiv
      # TODO: specify package
      #alias -s png="sxiv"
      #alias -s jpg="sxiv"
      #alias -s jpeg="sxiv"
      #alias -s webp="sxiv"

      # -- options
      # strip superfluous blanks before adding to history, e.g. 'vi  foo ' -> 'vi foo'
      setopt HIST_REDUCE_BLANKS
    '';

    # -- Plugins
    enableAutosuggestions = true;
    syntaxHighlighting = {
      enable = true;
      # TODO: nix-colors
      #styles = {};
    };
    plugins = [
      {
        # allows for using zsh inside the nix ephemeral shell
        name = "zsh-nix-shell";
        file = "nix-shell.plugin.zsh";
        src = "${pkgs.zsh-nix-shell}/share/zsh-nix-shell";
      }
      {
        # jump back to a specific directory, without doing `cd ../../..`
        name = "zsh-bd";
        file = "bd.zsh";
        src = "${pkgs.zsh-bd}/share/zsh-bd";
      }
      {
        # replace zsh's default completion selection menu with fzf
        # NOTE: this plugin uses the results of zsh completion so enabling zsh completion is still necessary.
        # This simply replaces the built-in menu.
        name = "fzf-tab";
        file = "fzf-tab.zsh";
        src = "${pkgs.zsh-fzf-tab}/share/fzf-tab";
      }
    ];
  };
}
