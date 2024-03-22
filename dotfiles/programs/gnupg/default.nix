{ config, pkgs, ... }:

{
  programs.gpg = {
    enable = true;
    homedir = "${config.xdg.dataHome}/gnupg";
    # as all the default options are set you can encrypt a file simply by typing 'gpg /path/to/file'
    # and then entering a password when prompted
    # decrypting is the same commmand but pointing to the encrypted file
    # TODO: fix it so that this does not conflict with --recv or --verify
    settings = {
      symmetric = true;
      no-symkey-cache = true;
      s2k-cipher-algo = "AES256";
    };
  };
  services.gpg-agent = {
    enable = true;
    pinentryPackage = pkgs.pinentry-tty;
  };
}
