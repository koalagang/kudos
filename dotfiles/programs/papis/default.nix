{
  programs.papis = {
    enable = true;
    settings = {
      opentool = "zathura"; # may consider changing to sioyek
    };
    libraries = {
      books = {
        name = "books";
        settings = {
          dir = "~/Documents/libraries/books";
        };
      };
      papers = {
        name = "papers";
        isDefault = true;
        settings = {
          dir = "~/Documents/libraries/papers";
        };
      };
    };
  };
}
