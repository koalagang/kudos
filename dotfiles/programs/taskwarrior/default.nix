# See A Dive into Taskwarrior Ecosystem with Tomas Babej (https://www.youtube.com/watch?v=tijnc65soEI)
# for a really great video on taskwarrior

{ config, pkgs, ... }:

{
  programs.taskwarrior = {
    enable = true;
    package = pkgs.taskwarrior3;

    # use the terminal's base16 colourscheme
    colorTheme = "dark-16";

    config = {
      # Sunday is on the weekend, mate
      weekstart = "Monday";

      # Make setting due date easier, e.g.
      # $ task add dentist appointment due:26-2
      # This will set the due date of 'dentist appointment' to 26 February this year
      # If your task is not due this year, just use Y-M-D (e.g. 2025-02-26)
      dateformat = "d-m";

      # running `task next` should never show me more than 5 tasks
      # and this should only include tasks I can currently complete
      report.next.filter = "+PENDING -WAITING -BLOCKING limit:5";

      # some of these aliases might be predefined
      alias = {
        a = "add";
        bd = "burndown.daily";
        bm = "burndown.monthly";
        bw = "burndown.weekly";
        by = "burndown.yearly";
        c = "calendar";
        d = "delete";
        e = "edit";
        f = "done"; # f for finish
        i = "information";
        l = "list";
        m = "modify";
        n = "annotate"; # n for note
      };

      # Set 'low priority' to reduce the urgency
      # (by default it increases it by 1.8)
      urgency.uda.priority.L.coefficient = -1.8;

      hooks.location = "${config.xdg.configHome}/taskwarrior/hooks";
      data.location = "${config.xdg.dataHome}/taskwarrior";
    };
  };

  home = {
    shellAliases = {
      ta = "task"; # yes, I am that lazy

      # Credits to u/Andonome (OP) for this one
      # https://www.reddit.com/r/taskwarrior/comments/uvwqlz/share_your_aliases/
      tal = "task add dep:\"$(task +LATEST uuids)\"";
      # Every task created with tal is a dependency of the most recently created task.
      # Thus, you can chain a series of dependencies together.

      # taskopen allows for more advanced annotations
      # see below for config
      to = "taskopen";
    };

    # install and configure taskopen
    packages = [ pkgs.taskopen ];
    file."${config.xdg.configHome}/task/taskopenrc".text = ''
      TASKBIN='${pkgs.taskwarrior3}/bin/task'
      # Directory has to be manually created
      NOTES_FOLDER="$HOME/Documents/neorg/tasknotes/" # the leading slash here is important
      NOTES_EXT=".norg" # Neorg
      PATH_EXT=${pkgs.taskopen}/share/taskopen/scripts
    '';
    sessionVariables.TASKOPENRC = "${config.xdg.configHome}/task/taskopenrc";
    persistence."/persist/nocow/home/dante".directories = [ ".local/share/taskwarrior" ];
  };
}
