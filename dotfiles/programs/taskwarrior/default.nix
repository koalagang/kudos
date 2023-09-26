# See A Dive into Taskwarrior Ecosystem with Tomas Babej (https://www.youtube.com/watch?v=tijnc65soEI)
# for a really great video on taskwarrior

{ pkgs, ... }:

{
  programs.taskwarrior = {
    enable = true;

    # will add my own dracula theme at some point
    colorTheme = "dark-256";

    config = {
      # Sunday is on the weekend, mate
      weekstart = "Monday";

      # running `task next` should never show me more than 20 tasks
      report.next.filter = "+PENDING -BLOCKING limit:20";

      alias = {
        a = "add";
        an = "annotate";
        c = "done";
        d = "delete";
        m = "mod";
        n = "next";
        s = "start";
      };

      # Set 'low priority' to reduce the urgency
      # (by default it increases it by 1.8)
      urgency.uda.priority.L.coefficient = -1.8;

      hooks.location = "$XDG_CONFIG_HOME/task/hooks";
    };
  };

  home = {
    # yes, I am that lazy
    shellAliases = { ta = "task"; };

    # hooks are written in python
    packages = with pkgs; [ python3 ];

    # install a hook which invokes timewarrior whenever I run `task start <ID>`
    file.".config/task/hooks/on-modify.timewarrior" = {
      source = ./on-modify.timewarrior;
      executable = true;
    };
  };
}
