{ inputs, lib, pkgs, ... }:

# !!! NOTE: WHENEVER MAKING CHANGES TO THIS FILE, ALWAYS USE `nixos-rebuild boot` !!!
# USING `switch` or `test` CAN POTENTIALLY CRASH YOUR SYSTEM AND FORCE YOU TO DO A HARD REBOOT

{
  imports = [
    # import disko to manage btrfs partitions and subvolumes
    (import ./disko.nix)
    inputs.disko.nixosModules.default

    # import impermanence to mount persistent files to their respective locations
    inputs.impermanence.nixosModules.impermanence

    # import lanzaboote to enable secure boot
    inputs.lanzaboote.nixosModules.lanzaboote
  ];

  boot = {
    loader = {
      systemd-boot = {
        # lanzaboote currently replaces the systemd-boot module
        # so we force the regular NixOS module to false
        enable = lib.mkForce false;
        editor = false; # recommended for security
        # limit the number of generations accessible with systemd-boot to save space in the ESP (/boot)
        configurationLimit = 30;
      };
      # set wait time to 1 second (boot in faster)
      timeout = 1;
    };

    # enable secure boot
    lanzaboote = {
      enable = true;
      pkiBundle = "/etc/secureboot";
    };

    # add a nice boot/shutdown animation
    # NOTE: to make this look smooth, you'll need to set the right kernel parameters and enable systemd in initrd (see below)
    plymouth = {
      enable = true;
      # TODO: open issue about the package missing mocha, frappe and latte
      themePackages = [ pkgs.catppuccin-plymouth ];
      theme = "catppuccin-macchiato";
    };

    # clean up the boot process (hides some stuff that slips through plymouth)
    consoleLogLevel = 0;
    initrd.verbose = false;
    kernelParams = [
      "quiet"
      "splash"
      "loglevel=3"
      "rd.systemd.show_status=false"
      "rd.udev.log_level=3"
      "udev.log_priority=3"
    ];

    initrd.systemd = {
      enable = true;
      # system packages are not accessible to the initrd so we need to make the necessary ones available
      packages = with pkgs; [
      	util-linux  # mount and umount
	coreutils   # mkdir and mv
	btrfs-progs # btrfs
      ];
      services.cleanup = {
        description = "Perform cleanup of impermanent files";
        wantedBy = [ "initrd.target" ];
        before = [ "sysroot.mount" ];
        after = [ "systemd-cryptsetup@crypted.service" ]; # run the service after unlocking the encrypted partition
        unitConfig.DefaultDependencies = "no";
        serviceConfig.Type = "oneshot";
        # wipe the system clean (except for /boot, /nix and /persist)
        script = ''
          # create a temporary directory and mount the btrfs filesystem onto it
          mkdir /btrfs_tmp
          mount /dev/mapper/crypted /btrfs_tmp -t btrfs

          # make sure that the directory got mounted correctly
          if [ -e /btrfs_tmp/root ]; then
          	# create a directory for the old roots if it does not already exist...
          	mkdir -p /btrfs_tmp/old_roots
          	# ...and move the current root into this directory with the timezone and timestamp as the name
          	# e.g. BST-2024-08-25T15-24-21 (24 minutes and 21 seconds past 3pm on the 25th August 2024 British Summer Time)
          	# this allows us to backup our old roots in case anything goes wrong (such as a system crash)
          	mv /btrfs_tmp/root "/btrfs_tmp/old_roots/$(date --date="@$(stat -c %Y /btrfs_tmp/root)" "+%Z-%Y-%m-%-dT%H-%M-%S")"
          fi

          # recursively delete subvolumes older than 30 days
          # NOTE: do not add quotation marks around the command substitutions used here
	  # -- this will break the script because the for loops need to see the results as multiple elements
	  # but wrapping the command substitutions in quotes will make them single elements
          delete_subvolume_recursively() {
          	IFS=$'\n'
          	for i in $(btrfs subvolume list -o "$1" | cut -f 9- -d' '); do
          	    delete_subvolume_recursively "/btrfs_tmp/$i"
          	done
          	btrfs subvolume delete "$1"
          }
          for i in $(find /btrfs_tmp/old_roots/ -maxdepth 1 -mtime +30); do
          	delete_subvolume_recursively "$i"
          done

          # create a new root subvolume to replace the one we just moved
          btrfs subvolume create /btrfs_tmp/root

          # unmount the temporary directory
          umount /btrfs_tmp
        '';
      };
    };
  };

  # mark /persist as needed for boot because this is required to allow impermenance to work with it
  fileSystems."/persist".neededForBoot = true;
  # use impermenance module to mount persistent system files to their respective locations
  environment.persistence = {
    "/persist/system" = {
      enable = true;
      # hide the bind mounts from showing up as mounted drives in file managers
      hideMounts = true;

      # a neat way to find what to persist is to issue the following rsync command:
      # doas rsync -amvxx --dry-run --no-links --exclude '/tmp/*' --exclude '/root/*' / /persist/ | rg -v '^skipping|/$'
      # credit: https://willbush.dev/blog/impermanent-nixos/
      directories = [
        # VERY IMPORTANT TO PERSIST
        # see https://github.com/nix-community/impermanence/issues/178
        "/var/lib/nixos"
        "/etc/secureboot" # ALSO VERY IMPORTANT TO PERSIST IF YOU USE LANZABOOTE
        "/var/lib/iwd" # remember wifi networks
        "/var/lib/power-profiles-daemon" # remember power profile (set using powerprofilesctl set <profile>)
        "/etc/mullvad-vpn" # persist Mullvad VPN login and settings
      ];
    };
    # use the nocow directory for virtual machines and other stuff that is written to very often
    # this is to reduce SSD wear when using btrfs
    # make sure to run chattr +C on /persist/nocow on new installations before first boot
    "/persist/nocow/system" = {
      enable = true;
      hideMounts = true;
      directories = [
        "/var/log" # keep system logs
        "/var/lib/libvirt" # store virtual machines (VERY IMPORTANT TO STORE IN nocow)
      ];
    };
  };

  # some options to allow for the impermenance home-manager module to be used
  systemd.tmpfiles.rules = [
    "d /persist/home 0777 root root -" # make /persist/home owned by root
    "d /persist/home/dante 0700 dante users -" # make /persist/home/dante owned by dante
    # same as above but for nocow
    "d /persist/nocow/home 0777 root root -"
    "d /persist/nocow/home/dante 0700 dante users -"
  ];
  programs.fuse.userAllowOther = true; # needed for root operations
}
