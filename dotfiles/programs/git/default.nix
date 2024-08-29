{ pkgs, config, ... }:

{
  programs.git = {
    enable = true;

    userEmail = "74791721+koalagang@users.noreply.github.com";
    userName = "koalagang";

    # A structural diff tool that understands syntax
    # TODO: nix-colors
    difftastic.enable = true;

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
      # TODO: nix-colors
      l = ''log --graph
        --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr)%Creset'
        --abbrev-commit --date=relative'';
    };

    # workaround for a bug
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
      ${pkgs.coreutils}/bin/cut -d' ' -f2 | ${pkgs.xclip}/bin/xclip -select clipboard
    '';
  };
}
