# can't get it to work atm
# wondering if this is related https://github.com/nix-community/home-manager/issues/1865
{
  services.wlsunset = {
    enable = true;
    temperature = {
      day = 6500;
      night = 2500;
    };
    sunrise = "06:00";
    sunset = "19:00";
  };
}
