{ config, pkgs, ... }:

# See https://thevaluable.dev/zsh-install-configure-mouseless/
# and https://thevaluable.dev/zsh-completion-guide-examples/
# to learn how the contents of completionInit and initExtra below work.

{
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
        src = "${pkgs.zsh-nix-shell}/share/zsh-nix-shell";
      }

      {
        # auto-close and delete matching delimiters
        name = "zsh-autopair";
        file = "autopair.zsh";
        src = "${pkgs.zsh-autopair}/share/zsh/zsh-autopair";
      }
    ];

    # -- vi mode
    defaultKeymap = "viins"; # start zsh in vi insert mode
    initExtra = ''
      # Load complist module to allow rebinding menu keys
      zmodload zsh/complist

      # use vi keys in tab complete menu
      bindkey -M menuselect 'h' vi-backward-char
      bindkey -M menuselect 'j' vi-down-line-or-history
      bindkey -M menuselect 'k' vi-up-line-or-history
      bindkey -M menuselect 'l' vi-forward-char
      bindkey '^?' backward-delete-char # fix backspace bug when switching modes

      # enter zsh's vi normal mode with escape
      bindkey '^[' vi-cmd-mode
      export KEYTIMEOUT=1

      # edit line in vim buffer with ctrl+v when in zsh's vi normal mode
      autoload -U edit-command-line && zle -N edit-command-line && bindkey -M vicmd '^v' edit-command-line

      # open vim with ctrl+v in zsh's vi insert mode
      bindkey -s '^v' 'vi^M'

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
      alias -s rs="${config.home.sessionVariables.EDITOR}"   # rust
      alias -s sh="${config.home.sessionVariables.EDITOR}"   # shell
      alias -s gd="${config.home.sessionVariables.EDITOR}"   # gdscript

      # documents
      alias -s md="${config.home.sessionVariables.EDITOR}"   # markdown
      alias -s norg="${config.home.sessionVariables.EDITOR}" # neorg
      alias -s tex="${config.home.sessionVariables.EDITOR}"  # latex
      alias -s txt="${config.home.sessionVariables.EDITOR}"  # regular, uninterpreted text
      alias -s docx="${pkgs.libreoffice}/bin/swriter"        # office document
      alias -s xlsx="${pkgs.libreoffice}/bin/scalc"          # spreadsheet

      # video and audio files
      alias -s mp4="${pkgs.mpv}/bin/mpv"
      alias -s mkv="${pkgs.mpv}/bin/mpv"
      alias -s webm="${pkgs.mpv}/bin/mpv"
      alias -s mp3="${pkgs.mpv}/bin/mpv"
      alias -s flac="${pkgs.mpv}/bin/mpv"

      # image files
      # swiv is a wayland port of sxiv
      # TODO: specify package
      #alias -s png="sxiv"
      #alias -s jpg="sxiv"
      #alias -s jpeg="sxiv"
      #alias -s webp="sxiv"

      # I've included these aliases in initExtra because I don't believe homemanager has an option for suffix aliases.
      # It only has global aliases and regular aliases.
    '';
  };
}
