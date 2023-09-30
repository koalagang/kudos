{ config, pkgs, ... }:

# See https://thevaluable.dev/zsh-install-configure-mouseless/
# and https://thevaluable.dev/zsh-completion-guide-examples/
# to learn how the contents of completionInit and initExtra below work.

{
  programs.zsh = {
    enable = true;

    # where to store the zshrc and zshenv
    # can't use ${config.xdg.configHome} because then it does /home/user//home/user/.config/zsh/.zshenv
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

    # -- vi mode
    defaultKeymap = "viins"; # start zsh in vi insert mode
    initExtra = ''
        # Load complist module to allow rebinding menu keys
        zmodload zsh/complist

        # enter vi mode with escape
        bindkey '^[' vi-cmd-mode
        export KEYTIMEOUT=1

        # edit line in vim buffer with ctrl-v when in vi mode
        autoload -U edit-command-line && zle -N edit-command-line && bindkey -M vicmd "^v" edit-command-line

        # use vi keys in tab complete menu
        bindkey -M menuselect 'h' vi-backward-char
        bindkey -M menuselect 'j' vi-down-line-or-history
        bindkey -M menuselect 'k' vi-up-line-or-history
        bindkey -M menuselect 'l' vi-forward-char
        bindkey "^?" backward-delete-char # fix backspace bug when switching modes
    '';

    # -- History
    history = {
      extended = true; # sav timestamps into the history file
      ignorePatterns = [ # do not add these (very dangerous) commands to the history
        "rm *"
        "rm -rf *"
        "pkill *"
      ];
      ignoreSpace = true; # do not save commands beginning with a space
      path = "${config.xdg.dataHome}/zsh/zsh_history";
      # save 10,000 lines (this is actually the default behaviour)
      save = 10000;
      size = 10000;
      share = true;
    };

    # -- Plugins
    historySubstringSearch = {
      # Search through history by typing a part of the command you're searching for
      # and then hitting ctrl+k or ctrl+j to query the history
      enable = true;
      searchUpKey = "^K";
      searchDownKey = "^J";
    };
    enableAutosuggestions = true;
    syntaxHighlighting = {
      enable = true;
      # TODO: nix-colors
      #styles = {};
    };
  };

  # My favourite prompt
  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    settings.line_break.disabled = true;
  };

  # A smarter cd command
  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
  };
  home.sessionVariables = {
    # zoxide configuration
    _ZO_DATA_DIR = "${config.xdg.dataHome}/zsh";
    _ZO_MAXAGE = 10000;
    _ZO_RESOLVE_SYMLINKS = 1;
  };
}
