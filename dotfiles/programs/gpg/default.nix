{ config, ... }:

{
  programs.gpg = {
    enable = true;
    homedir = "${config.xdg.configHome}/gnupg";
    # as all the default options are set you can encrypt a file simply by typing 'gpg /path/to/file'
    # and then entering a password when prompted
    # decrypting is just as easy (except this time you enter the password you previously typed)
    settings = {
      symmetric = true;
      no-symkey-cache = true;
      s2k-cipher-algo = "AES256";
    };
  };
  services.gpg-agent = {
    enable = true;
    pinentryFlavor = "curses";
  };
}
