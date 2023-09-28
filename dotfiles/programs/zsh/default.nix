{ config, ... }:

{
  programs.zsh = {
    enable = true;

    # Completion
    # TODO: add environment.pathsToLink = [ "/share/zsh" ];
    # to your system configuration to get completion for system packages (e.g. systemd).
    enableCompletion = true;
    # Allow entering directories by entering path into shell (without need for 'cd' command)
    autocd = true;
    # not exactly sure what all these do
    # I just grabbed it from my old zsh config (of which I likely grabbed from somewhere else)
    completionInit = ''
      autoload -U compinit && compinit -u
      zstyle ':completion:*' menu select
      zstyle ':completion:*' matcher-list "" 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
      zmodload zsh/complist
      _comp_options+=(globdots) # include hidden files
      zstyle ':completion:*' cache-path ${config.xdg.cacheHome}/zsh/zcompcache
    '';

    # vi mode
    defaultKeymap = "viins"; # vi insert mode
    initExtra = ''
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

    # where to store the zshrc and zshenv
    dotDir = ".config/zsh";

    # history
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

    # Plugins
    enableAutosuggestions = true;
    syntaxHighlighting = {
      enable = true;
      # TODO
      #styles = {};
    };
    # TODO: test this (might be a good alternative to searching the history with fzf)
    #historySubstringSearch = {
    #  enable = true;
    #  # TODO: more options
    #};
    # TODO: add fish-like abbreviations (such as G for '| grep')
    #plugins = {};
  };

  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    settings.line_break.disabled = true;
  };

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
  # TODO: add misc environmental variables to home.nix
  # - most of these will be configured in the respective files for the software being aliased
  # e.g. will set foot to TERMINAL in its config file after I've migrated to wayland
  # nvim has defaultEditor = true (i.e. EDITOR=nvim)
  # will not need PATH once I've ported scripts to writeShellScriptBin because all scripts will be in the nix store
  # will set firefox to BROWSER

  # TODO: aliases and functions
  # - most of these will be configured in the respective files for the software being aliases
  # e.g. adding fzf aliases to fzf's config directory
}
