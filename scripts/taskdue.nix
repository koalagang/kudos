{ pkgs, ... }:

{
  home = {
    packages = [
      (pkgs.writeShellScriptBin "taskdue" ''
        if [ -n "$3" ]; then
          day="$1"
          month="0$(($2+1))" # eww begins indexing the month at 0 for some reason
          year="$3"
          DUE="$(${pkgs.taskwarrior}/bin/task due:$year-$month-$day list | ${pkgs.coreutils}/bin/tail -1)"
          [ -n "$DUE" ] && notify-send "$DUE due on $day/$month/$year"
        else
          # Notify of number of tasks overdue
          OVERDUE="$(${pkgs.taskwarrior}/bin/task +OVERDUE list | ${pkgs.coreutils}/bin/tail -1)"
          [ -n "$OVERDUE" ] && ${pkgs.libnotify}/bin/notify-send 'taskwarrior' "You have $OVERDUE overdue"

          # Notify of number of tasks due today
          TODAY="$(${pkgs.taskwarrior}/bin/task +TODAY list | ${pkgs.coreutils}/bin/tail -1)"
          [ -n "$TODAY" ] && ${pkgs.libnotify}/bin/notify-send 'taskwarrior' "You have $TODAY due TODAY"

          # Notify of number of tasks due at any point in time
          ALL="$(${pkgs.taskwarrior}/bin/task due.any: list | ${pkgs.coreutils}/bin/tail -1)"
          [ -n "$ALL" ] && ${pkgs.libnotify}/bin/notify-send 'taskwarrior' "You have a total of $ALL due"
        fi
      '')
    ];
  };
}
