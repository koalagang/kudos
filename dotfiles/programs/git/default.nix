{ pkgs, config, ... }:

{
  programs.git = {
    enable = true;

    userEmail = "74791721+koalagang@users.noreply.github.com";
    userName = "koalagang";

    # A structural diff tool that understands syntax
    difftastic = {
      enable = true;
      background = "dark";
      color = "always";
      display = "side-by-side";
    };

    aliases = {
      a = "add";
      c = "clone";
      m = "commit -m";
      o = "checkout";
      d = "diff";
      p = "push";
      pl = "pull";
      r = "rm";
      rs= "restore --staged";
      s = "status";
      # Credits to OP for this alias: https://www.reddit.com/r/git/comments/1ajh2ll/my_favorite_alias_for_git_log/
      l = "log --graph --pretty=format:'%C(#${config.colorScheme.palette.base0E})%h%Creset -%C(#${config.colorScheme.palette.base0F})%d%Creset %s %C(#${config.colorScheme.palette.base0B})(%cr)%Creset' --abbrev-commit --date=relative";
    };

    # WORKAROUND:
    # see https://discourse.nixos.org/t/nixos-rebuild-switch-fails-under-flakes-and-doas-with-git-warning-about-dubious-ownership/46069/12
    # an alternative solution presented by Tmplt which weirdly works is staging an empty file
    extraConfig.safe.directory = "${config.xdg.userDirs.desktop}/git/kudos/.git";
  };
  home.shellAliases = {
    g = "git"; # yes, I am that lazy
    diff = "difft"; # difftastic
    # Search the git log and copy the commit to the clipboard
    glf = ''
      ${pkgs.git}/bin/git log --graph --decorate --pretty=oneline --abbrev-commit | ${pkgs.fzf}/bin/fzf | \
      ${pkgs.coreutils}/bin/cut -d' ' -f2 | ${pkgs.wl-clipboard}/bin/wl-copy
    '';
  };
}
