{
  programs.git = {
    enable = true;

    userEmail = "74791721+koalagang@users.noreply.github.com";
    userName = "koalagang";

    difftastic.enable = true;

    aliases = {
      a = "add";
      c = "clone";
      cm = "commit -m";
      co = "checkout";
      d = "diff";
      p = "push";
      pl = "pull";
      r = "rm";
      rs= "restore --staged";
      s = "status";
      lol = "log --graph --decorate --pretty=oneline --abbrev-commit";
    };

  };
  # yes, I am that lazy
  home.shellAliases = { g = "git"; };
}
