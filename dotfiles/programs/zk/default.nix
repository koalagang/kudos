{ pkgs, ... }:

# Obsidian can't see dotfiles, so whenever initialising a zk notebook inside an obsidian vault,
# make sure to symlink the template directories together so that both apps can make use of the same templates:
# $ ln -s ../templates .zk

{
  programs.zk = {
    enable = true;
    settings = {
      note = {
        language = "en";
        default-title = "untitled";
        filename = "{{id}}-{{slug title}}";
        extension = "md";
        # 36^4 different combinations available
        id-charset = "alphanum";
        id-length = 4;
        id-case = "lower";
      };
      tool = {
        # TODO: figure out how to make a glow
        fzf-preview = "${pkgs.glow}/bin/glow --pager -s dark {-1}";
        # everything except for the bindings are default options
        # (just have to add it because adding your own flags overrides the defaults)
        fzf-options = "--bind ctrl-u:preview-up,ctrl-d:preview-down --tiebreak begin --exact --tabstop 4 --height 100% --layout reverse --no-hscroll --color hl:-1,hl+:-1 --preview-window wrap";
      };
    };
  };
}

