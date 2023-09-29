{ pkgs, ... }:

{
  home = {
    # install trash-cli
    packages = with pkgs; [ trash-cli ];

    # aliases
    shellAliases = {
      tp = "trash-put";
      te = "trash-empty";
      tl = "trash-list";
      # tr is already a different command so an 'e' is added
      tre = "trash-restore";
    };
  };
}
