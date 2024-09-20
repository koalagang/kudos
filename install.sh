#!/usr/bin/env bash

# I will probably expand this script to give the user more options when/if I setup NixOS on more devices
# but for now we'll just setup Myla

git clone https://github.com/koalagang/kudos.git

# partition the disk with disko
sudo nix --experimental-features "nix-command flakes" run github:nix-community/disko -- --mode disko $PWD/kudos/disko.nix

# the following part of the script is designed to allow us to securely generate hashes from user input
# and then verify that the passwords entered match
# without ever resorting to insecure techniques, such as storing plaintext passwords in variables

# create files that differ so that the while loop opens
echo 'pass' > pass.txt
echo 'pass2' > pass2.txt

while [[ "$(diff pass.txt pass2.txt -q)" == 'Files pass.txt and pass2.txt differ' ]]; do
	# print error if the loop has already been run
	[ -n "$pass_already" ] && printf '\nError: Passwords do not match. Please try again.\n'

	# generate a randoms salt
	salt="\$y\$j9T\$$(head -c 16 /dev/urandom | od -An -tx1 | tr -d ' \n' | cut -c1-32)"

	# by using the same salt, we can generate the same hash twice
	# this means we can confirm that the passwords match in case the user mistypes
	mkpasswd --salt=$salt -m yescrypt > pass.txt
	printf 'Re-type New '
	mkpasswd --salt=$salt -m yescrypt > pass2.txt
	
	# remember that we have completed this loop at least once
	pass_already=1
done
sudo mv pass.txt /mnt/persist/hashed-password
rm pass2.txt
echo "Password successfully set!"

# install NixOS without prompting for root password because it uses the hashed password file
sudo nixos-install --no-root-password --root /mnt --flake "$PWD/kudos/#Myla"

# set nodatacow
sudo mkdir -p /mnt/persist/nocow
sudo chattr -R +C /mnt/persist/nocow
sudo chattr -R +C /mnt/swap

echo "Install for Koala's Unified and Declarative Operating System (kudos) complete!"
echo 'Please reboot with the command `reboot` or shutdown with `shutdown now`.'
