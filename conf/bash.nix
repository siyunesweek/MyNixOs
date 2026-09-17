{ config, pkgs, ... }:

{
  programs.bash = {
    completion.enable = true;

    interactiveShellInit = ''
      export HISTFILE="$HOME/.bash_history_raw"
      export HISTSIZE=5000
      export HISTFILESIZE=5000
      export HISTCONTROL=ignoredups
      export HISTTIMEFORMAT="%d/%m/%Y %T  "

      __bash_history_log() {
        local cmd
        cmd=$(fc -ln -1 2>/dev/null | sed -e 's/^[[:space:]]*//')
        [ -z "$cmd" ] && return
        if [ "$cmd" != "$__bash_history_last_cmd" ]; then
          __bash_history_last_cmd="$cmd"
          printf '[%s] %s\n' "$(date '+%d/%m/%Y %H:%M:%S')" "$cmd" >> "$HOME/.bash_history"
        fi
      }
      PROMPT_COMMAND="__bash_history_log''${PROMPT_COMMAND:+; $PROMPT_COMMAND}"

      bind 'TAB: menu-complete'
      bind '"\e[Z": menu-complete-backward'
      bind 'set menu-complete-display-prefix on'
      bind 'set show-all-if-ambiguous on'

      alias r="~/scripts/music.sh" 
    '';
  };
}
