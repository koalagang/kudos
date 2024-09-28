# kudos
Koala's Unified and Declarative Operating System

will document this more when there are fewer moving parts

## Installation
> [!IMPORTANT]
> Whilst I make my NixOS config public for anyone to view and use, it is highly opinionated and personalised.
> It may be better to design your own system but take snippets you like from other people's dotfiles.

1. Boot into the BIOS and make sure secure boot is disabled
2. Boot into a NixOS live key
3. Run the one-command install, making sure to set your passwords when prompted:
```sh
nix run --experimental-features "nix-command flakes" github:koalagang/kudos --no-write-lock-file
```
4. Shutdown (`shutdown now`) and remove your USB stick from the computer and then turn your system back on
5. Post-installation requires a rebuild to deploy out-of-store symlinks (also set the power profile whilst we're at it)
> [!NOTE]
> Eventually, I plan to switch to using [nixvim](https://github.com/nix-community/nixvim) and the eww home-manager module,
> at which point this step will no longer be necessary.
```sh
# ~g simply means the git directory
# this is a hash directory set in my zsh config
mkdir -p ~g
cd ~g
git clone https://github.com/koalagang/kudos.git
mv kudos ~g/kudos
cd kudos
run nixos-rebuild switch --flake $PWD/#Myla

# set power profile
powerprofilesctl set power-saver
```
6. Configure all the imperative stuff:
    - Anki - sign into AnkiWeb account and make sure to install the plugins too:
        - [AnkiConnect](https://ankiweb.net/shared/info/2055492159) (2055492159)
        - [ReColor](https://ankiweb.net/shared/info/688199788) (688199788)
        - [FSRS4Anki](https://ankiweb.net/shared/info/759844606) (759844606)
        - [Review Heatmap](https://ankiweb.net/shared/info/1771074083) (1771074083)
    - Signal Desktop
    - LibreOffice (set the user interface to tabbed and make docx the default format)
7. (Optional) Setup secure boot:
> [!WARNING]
> Do not simply run the following commands blindly.
> Make sure to read through the [Lanzaboote guide](https://github.com/nix-community/lanzaboote/blob/master/docs/QUICK_START.md).
```sh
bootctl status # check that secure boot is supported by your computer
nix-shell -p sbctl
run sbctl create-keys
run sbctl verify # check that the keys were successfully created
shutdown now
# boot into the BIOS and wipe secure boot settings
# then boot back in and run the next commands
nix-shell -p sbctl
run sbctl enroll-keys --microsoft
shutdown now
# boot into the BIOS again and enable secure boot
# you should probably also set a BIOS password
# then boot back into your NixOS system and run the final command
bootctl status # check that secure boot has successfully been enabled
```
