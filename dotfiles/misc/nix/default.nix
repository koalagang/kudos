{
  nix.settings = {
    # Do not warn about dirty git tree
    # See https://discourse.nixos.org/t/what-does-warning-git-tree-a-path-is-dirty-mean-exactly/20568 for more
    warn-dirty = false;

    # Respect the XDG base directory spec
    use-xdg-base-directories = true;

    # Automatically run garbage collection whenever there is not enough space left
    # The below options tell nix to collect garbage when the partition with /nix has less than 20 GB free
    # but it will clear only as much as is necessary to free up 60 GB
    min-free = "${toString (1024 * 1024 * 1024 * 20 )}"; # 20 GB
    max-free = "${toString (1024 * 1024 * 1024 * 60 )}"; # 60 GB
  };
}
