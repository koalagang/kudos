{ pkgs, config, ... }:

{
  home.packages = [
    (pkgs.writeShellScriptBin "ddgmenu" ''
      # take user input for what to search and place it in a variable
      query="$(: | ${config.home.sessionVariables.DMENU_CMD} -p 'Search: ')"
      [ -z "$query" ] && exit 0 # exit if no input is given

      # lookup the contents of $query and give the user the first 20 available options
      # also store the json file for later use
      choice="$(${pkgs.ddgr}/bin/ddgr "$query" --json --gb -n 20 | ${pkgs.coreutils}/bin/tee '/tmp/ddgmenu.json' | \
        ${pkgs.jq}/bin/jq '.[].title' | ${pkgs.coreutils}/bin/tr -d '\\' | ${config.home.sessionVariables.DMENU_CMD} -l 20 -p ''')"
      [ -z "$choice" ] && exit 0 # exit if no input is given
      # remove the first and last quotation mark
      choice2="''${choice#'"'}"
      choice2="''${choice2%'"'}"

      # search ddgmenu.json for a title containing the contents of $choice2, grab the URL and then open it in the browser
      ${pkgs.jq}/bin/jq --arg choice "$choice2" '.[] | select(.title==$choice)' '/tmp/ddgmenu.json' | \
        ${pkgs.jq}/bin/jq '.url' | ${pkgs.findutils}/bin/xargs "${config.home.sessionVariables.BROWSER}"

      # cleanup
      ${pkgs.coreutils}/bin/rm -f '/tmp/ddgmenu.json'
    '')
  ];
}
