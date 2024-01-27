{ pkgs, ... }:

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
      l = "log --graph --decorate --pretty=oneline --abbrev-commit";
    };

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
