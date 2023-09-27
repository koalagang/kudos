{
  programs.git = {
    enable = true;

    userEmail = "74791721+koalagang@users.noreply.github.com";
    userName = "koalagang";

    # A structural diff tool that understands syntax
    difftastic.enable = true;

    aliases = {
      a = "add";
      c = "clone";
      m = "commit -m";
      o = "checkout";
      d = "diff";
      p = "push";
      l = "pull";
      r = "rm";
      rs= "restore --staged";
      s = "status";
      lol = "log --graph --decorate --pretty=oneline --abbrev-commit";
    };

  };
  # yes, I am that lazy
  home.shellAliases = { g = "git"; };
}
