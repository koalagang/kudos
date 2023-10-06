{
  name = "browsing";
  isDefault = true;
  settings = import ../settings.nix;
  search = {
    force = true;
    default = "DuckDuckGo";
    order = [
      "DuckDuckGo"
      "Wikipedia (en)"
      "Nix Options"
      "Nix Packages"
      "Amazon.co.uk"
      "eBay"
    ];
    engines = {
      "Nix Packages" = {
        urls = [{ template = "https://search.nixos.org/options?type=packages&query={searchTerms}"; }];
        iconUpdateURL = "https://nixos.wiki/favicon.png";
        definedAliases = [ "@np" ];
      };
      "Nix Options" = {
        urls = [{ template = "https://search.nixos.org/options?type=options&query={searchTerms}"; }];
        iconUpdateURL = "https://nixos.wiki/favicon.png";
        definedAliases = [ "@no" ];
      };

      # disable these
      "Bing".metaData.hidden = true;
      "Google".metaData.hidden = true;

      # add aliases for these
      "Wikipedia (en)".metaData.alias = "@w";
      "Amazon.co.uk".metaData.alias = "@a";
      "eBay".metaData.alias = "@e";
    };
  };
  # TODO: add NUR
  #extensions = {
  #};
}
