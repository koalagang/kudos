{ pkgs, ... }:

# Just a couple temporary pomodoro scripts.
# I intend to write a more substantial timeboxing tool
# so I'm only using these for the time being.

{
  home = {
    packages = [
      (pkgs.writeShellScriptBin "pomo-work" ''
      ${pkgs.timewarrior}/bin/timew start "$1" >/dev/null
      ${pkgs.timer}/bin/timer 45m
      ${pkgs.timewarrior}/bin/timew stop "$1" >/dev/null
      ${pkgs.speechd}/bin/spd-say 'Time for a break!' && ${pkgs.libnotify}/bin/notify-send 'Time for a break'
      '')
      (pkgs.writeShellScriptBin "pomo-break" ''
      ${pkgs.timer}/bin/timer 15m
      ${pkgs.speechd}/bin/spd-say 'Break is over!' && ${pkgs.libnotify}/bin/notify-send 'Break is over!'
      '')
    ];
  };
}
