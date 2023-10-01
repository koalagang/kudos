{
  nix.settings = {
    # Tell nix to stop dumping stuff into my home directory
    use-xdg-base-directories = true;

    # Tell nix to stfu about git
    warn-dirty = false;
  };
}
