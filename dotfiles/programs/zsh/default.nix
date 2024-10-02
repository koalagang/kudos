{ config, pkgs, ... }:

{
  imports = [ ./theme.nix ];

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

      # squeeze slashes, e.g. //h completes to /home
      zstyle ':completion:*' squeeze-slashes true

      # show directory preview using fzf when completing cd commmand (depends on fzf-tab)
      zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --color=always --icons=always $realpath'
    '';

    # -- History
    history = {
      path = "${config.xdg.dataHome}/zsh/zsh_history";
      extended = true; # save timestamps into the history file
      # do not add these very dangerous commands to the history
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

        # misc
        "timew delete"
      ];
      # do not save commands beginning with a space
      # (useful for if you want to enter a command that you don't want in your history, e.g. one containing a password)
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
    # this includes functions, bindings (bindkey), suffixes (alias -s) and some options (setopt)
    initExtra = ''
      # Load complist module to allow rebinding keys
      zmodload zsh/complist

      # -- vi and vim
      # enter zsh's vi normal mode (vicmd) with escape
      bindkey '^[' vi-cmd-mode
      export KEYTIMEOUT=1
      bindkey '^?' backward-delete-char # fix backspace bug when switching modes

      # change cursor shape for different vi modes
      zle-keymap-select() {
        case "$KEYMAP" in
          vicmd) printf '\e[1 q' ;;   # block
          viins|main) printf '\e[5 q' # beam
        esac
      }
      zle -N zle-keymap-select
      _fix_cursor() {
         printf '\e[5 q'
      }
      precmd_functions+=(_fix_cursor)

      # edit line in vim buffer with ctrl+v when in vicmd
      autoload -U edit-command-line && zle -N edit-command-line && bindkey -M vicmd '^v' edit-command-line

      # open vim with ctrl+v in zsh's vi insert mode
      bindkey -s '^v' 'vi^M'

      # -- misc bindings
      # Fixes issue where I can't use fzf's cd widget (left alt + c doesn't give any input).
      # This weird letter is basically just right-alt (sometimes called AltGr) + c.
      bindkey '¢' fzf-cd-widget

      # search zoxide database using fzf and enter the selected path with ctrl+f
      zoxide_interactive(){
        local selection="$(${pkgs.zoxide}/bin/zoxide query --interactive)"
        [ -n "$selection" ] && cd "$selection"
        zle reset-prompt
      }
      zle -N zoxide_interactive
      bindkey '^f' zoxide_interactive

      # quickly push an application (e.g. vim) into the background with ctrl+z
      # and then just as quickly pull it into the foreground again with ctrl+z
      bindkey -s '^z' 'fg^M'

      # -- suffix aliases
      # Like autocd but for files.
      # Any of the following formats can be opened in the respective software just by entering the filepath
      # (no need for prefixing it with vim or anything else).
      # This is particularly useful with the ctrl+t fzf widget
      # because it allows you to simply search for the file with fzf and then hit enter twice to open it.

      alias -s {lua,nix,rs,gd,yuck,md,markdown,mdown,norg,tex,txt,ini,conf,cfg,toml,scss}="${config.home.sessionVariables.EDITOR}"

      # wysiwig documents and spreadsheets
      alias -s {odf,docx,doc,xlsx,csv,tsv}="${pkgs.libreoffice}/bin/libreoffice --nologo"

      # video and audio files
      alias -s {flac,mp3,mp4,mkv,webm}="${pkgs.mpv}/bin/mpv"

      # image files
      alias -s {png,jpg,jpeg,webp}="${pkgs.imv}/bin/imv"

      # pdfs
      alias -s pdf="${pkgs.zathura}/bin/zathura"

      # -- options
      setopt HIST_REDUCE_BLANKS     # strip superfluous blanks before adding to history, e.g. `vi  foo ` -> `vi foo`
                                    # note that this does not apply to arguments in quotes,
                                    # e.g. `echo 'hello    world'` does not change
                                    # file globbing
      setopt NOMATCH                # produce an error if no match is found
      setopt AUTOPUSHD PUSHDSILENT  # make cd commmand use pushd and don't print dirs whenever you run it
                                    # this can be thought of as dynamically creating per-session aliases
                                    # TODO: add completion for cd or pushd commands beginning with tilda~
      # `man zshoptions` for more

      # -- functions and modules
      # automatically run eza whenever you cd into a new directory
      # basically just an eza version of auto-ls (https://github.com/aikow/zsh-auto-ls)
      auto_eza() {
        emulate -L zsh
        ${pkgs.eza}/bin/eza --all --long --no-permissions --no-user --no-time --group-directories-first --sort=size \
          --binary --colour=always --icons=always
      }
      chpwd_functions=(auto_eza $chpwd_functions)

      # calculator
      # make sure *not* to use spaces (e.g. `zc 2*3`, not `zc 2 * 3`)
      autoload -U zcalc
      alias 'zc'='noglob zcalc -f -e'

      # bulk mv/cp files by means of shell patterns
      autoload -U zmv
      alias zr='noglob zmv -W -M'  # easily rename files (demonstrated below)
      alias zcp='noglob zmv -W -C' # same as above but cp instead of mv
                                   # useful for backing up files, e.g. $ zcp *.srt *.srt.bak
      # $ ls -1
      #   Gamers!.S01E01.JA.srt
      #   Gamers!.S01E02.JA.srt
      #   Gamers!.S01E03.JA.srt
      #   Gamers!.S01E04.JA.srt
      #   Gamers!.S01E05.JA.srt
      #   Gamers!.S01E06.JA.srt
      #   Gamers!.S01E07.JA.srt
      #   Gamers!.S01E08.JA.srt
      #   Gamers!.S01E09.JA.srt
      #   Gamers!.S01E10.JA.srt
      #   Gamers!.S01E11.JA.srt
      #   Gamers!.S01E12.JA.srt
      # $ zr Gamers\!.*.JA.srt *.srt
      # $ ls -1
      #   S01E01.srt
      #   S01E02.srt
      #   S01E03.srt
      #   S01E04.srt
      #   S01E05.srt
      #   S01E06.srt
      #   S01E07.srt
      #   S01E08.srt
      #   S01E09.srt
      #   S01E10.srt
      #   S01E11.srt
      #   S01E12.srt
    '';

    # -- Plugins
    plugins = [
      {
        # allows for using zsh inside the nix ephemeral shell
        name = "zsh-nix-shell";
        file = "nix-shell.plugin.zsh";
        src = "${pkgs.zsh-nix-shell}/share/zsh-nix-shell";
      }
      {
        # replace zsh's default completion selection menu with fzf
        # NOTE: this plugin uses zsh's native completion
        # so you should still enable and configure it just as you would otherwise
        # (see enableCompletion and completionInit earlier in the config).
        # This simply replaces the *menu*.
        name = "fzf-tab";
        file = "fzf-tab.zsh";
        src = "${pkgs.zsh-fzf-tab}/share/fzf-tab";
      }
      {
        name = "zsh-pipr";
        file = "pipr.plugin.zsh";
        src = pkgs.fetchFromGitHub {
          owner = "koalagang";
          repo = "zsh-pipr";
          rev = "62e4a240d4354ed90071d7007896efc15a2381db";
          hash = "sha256-zxu/uk/iL5jPHilnvhB647+2f4kC8KpAKDbvJPimy/0=";
        };
      }
      # TODO: install https://github.com/momo-lab/zsh-abbrev-alias
    ];
  };
  # plugin dependencies
  home.packages = with pkgs; [ fzf pipr ];
}
