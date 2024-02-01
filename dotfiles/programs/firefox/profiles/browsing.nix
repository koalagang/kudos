{ pkgs, inputs, ... }:

{
  programs.firefox.profiles.profile0 = {
    name = "browsing";
    id = 0;
    isDefault = true;

    search = {
      force = true;
      default = "DuckDuckGo";
      privateDefault = "DuckDuckGo";
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
          iconUpdateURL = "https://nixos.wiki/favicon.png"; # having trouble with nix-icons so I'm using this for now
          icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
          definedAliases = [ "@np" ];
        };
        "Nix Options" = {
          urls = [{ template = "https://search.nixos.org/options?type=options&query={searchTerms}"; }];
          iconUpdateURL = "https://nixos.wiki/favicon.png";
          icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
          definedAliases = [ "@no" ];
        };
        "Google Scholar" = {
          urls = [{ template = "https://scholar.google.co.uk/scholar?hl=en&as_sdt=0%2C5&q={searchTerms}"; }];
          #icon = "";
          definedAliases = [ "@g" ];
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

    # TODO: configure these extensions and add configs here with home.file
    extensions = with inputs.firefox-addons.packages."x86_64-linux"; [
      ublock-origin
      cookie-autodelete
      darkreader
      tridactyl # see below for tridactyl-native
    ];

  };

  # TODO: bukubrow
  # keepassxc?
  # TODO: nix-colors
  programs.firefox.nativeMessagingHosts = with pkgs; [
    tridactyl-native
  ];
}
