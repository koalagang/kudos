{
  nix.settings = {
    # Do not warn about dirty git tree
    # See https://discourse.nixos.org/t/what-does-warning-git-tree-a-path-is-dirty-mean-exactly/20568 for more
    warn-dirty = false;

    # Respect the XDG base directory spec
    use-xdg-base-directories = true;
  };
}
