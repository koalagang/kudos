{ config, ... }:

{
  programs.zsh = {
    syntaxHighlighting = {
      enable = true;
      highlighters = [
        "main"
        "brackets"
      ];
      # italic doesn't seem to work (see https://github.com/zsh-users/zsh-syntax-highlighting/issues/432)
      # but I'll put it in stuff I want italic anyway just in case it does work someday
      styles = {
        # main
        alias = "fg=#${config.colorScheme.palette.base07}";
        arg0 = "fg=#${config.colorScheme.palette.base05}";
        assign = "fg=#${config.colorScheme.palette.base05}";
        autodirectory = "fg=#${config.colorScheme.palette.base09},underline";
        back-dollar-quoted-argument = "fg=#${config.colorScheme.palette.base09}";
        back-double-quoted-argument = "fg=#${config.colorScheme.palette.base09}";
        back-quoted-argument = "fg=#${config.colorScheme.palette.base0E}";
        back-quoted-argument-delimiter = "fg=#${config.colorScheme.palette.base09}";
        back-quoted-argument-unclosed = "fg=#${config.colorScheme.palette.base08}";
        builtin = "fg=#${config.colorScheme.palette.base0E},italic";
        command = "fg=#${config.colorScheme.palette.base07}";
        command-substitution-delimiter = "fg=#${config.colorScheme.palette.base0F}";
        command-substitution-delimiter-quoted = "fg=#${config.colorScheme.palette.base0A}";
        command-substitution-delimiter-unquoted = "fg=#${config.colorScheme.palette.base0F}";
        command-substitution-quoted = "fg=#${config.colorScheme.palette.base0A}";
        commandseparator = "fg=#${config.colorScheme.palette.base09}";
        comment = "fg=#${config.colorScheme.palette.base04}";
        default = "fg=#${config.colorScheme.palette.base05}";
        dollar-double-quoted-argument = "fg=#${config.colorScheme.palette.base0F},bold";
        dollar-quoted-argument = "fg=#${config.colorScheme.palette.base05}";
        dollar-quoted-argument-unclosed = "fg=#${config.colorScheme.palette.base08}";
        double-hyphen-option = "fg=#${config.colorScheme.palette.base09}";
        double-quoted-argument = "fg=#${config.colorScheme.palette.base0B}";
        double-quoted-argument-unclosed = "fg=#${config.colorScheme.palette.base08}";
        function = "fg=#${config.colorScheme.palette.base07}";
        global-alias = "fg=#${config.colorScheme.palette.base07}";
        globbing = "fg=#${config.colorScheme.palette.base06}";
        hashed-command = "fg=#${config.colorScheme.palette.base07}";
        history-expansion = "fg=#${config.colorScheme.palette.base0E}";
        named-fd = "fg=#${config.colorScheme.palette.base05}";
        numeric-fd = "fg=#${config.colorScheme.palette.base0C}";
        path = "fg=#${config.colorScheme.palette.base05},underline";
        path_prefix = "fg=#${config.colorScheme.palette.base05},underline";
        precommand = "fg=#${config.colorScheme.palette.base0C},underline";
        process-substitution-delimiter = "fg=#${config.colorScheme.palette.base0F}";
        rc-quote = "fg=#${config.colorScheme.palette.base0A}";
        redirection = "fg=#${config.colorScheme.palette.base0A}";
        reserved-word = "fg=#${config.colorScheme.palette.base0E},italic";
        single-hyphen-option = "fg=#${config.colorScheme.palette.base09}";
        single-quoted-argument = "fg=#${config.colorScheme.palette.base0B}";
        single-quoted-argument-unclosed = "fg=#${config.colorScheme.palette.base08}";
        suffix-alias = "fg=#${config.colorScheme.palette.base07}";
        unknown-token = "fg=#${config.colorScheme.palette.base08},bold";
        # brackets
        bracket-level-1 = "fg=${config.colorScheme.palette.base0D},bold";
        bracket-level-2 = "fg=#${config.colorScheme.palette.base09},bold";
        bracket-level-3 = "fg=#${config.colorScheme.palette.base0B},bold";
        bracket-level-4 = "fg=#${config.colorScheme.palette.base0E},bold";
        bracket-error   = "fg=#${config.colorScheme.palette.base08},bold";
      };
    };
    autosuggestion = {
      enable = true;
      highlight = "fg=#${config.colorScheme.palette.base04}";
    };
  };
}
