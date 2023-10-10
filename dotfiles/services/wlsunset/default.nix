# can't get it to work atm
# wondering if this is related https://github.com/nix-community/home-manager/issues/1865
{
  services.wlsunset = {
    enable = true;
    temperature = {
      day = 2500;
      night = 2500;
    };
    # London
    latitude = "51.5";
    longitude = "-0.1";
  };
}

