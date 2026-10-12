{ config, pkgs, ... }:

{
  programs.bash = {
    completion.enable = true;

    # Anula el PS1 por defecto de NixOS
    promptInit = "";

    interactiveShellInit = ''
      export HISTFILE="$HOME/.bash_history_raw"
      export HISTSIZE=5000
      export HISTFILESIZE=5000
      export HISTCONTROL=ignoredups
      export HISTTIMEFORMAT="%F %T "

      export PROMPT_DIRTRIM=3

      # El prompt del venv lo dibujamos nosotros
      export VIRTUAL_ENV_DISABLE_PROMPT=1

      __set_prompt() {
        local exit=$?
        local rst='\[\e[0m\]'
        local bld='\[\e[1m\]'
        local red='\[\e[31m\]'
        local grn='\[\e[32m\]'
        local ylw='\[\e[33m\]'
        local blu='\[\e[34m\]'
        local pur='\[\e[35m\]'
        local gry='\[\e[90m\]'

        # (env) si hay un virtualenv activo
        local venv=""
        if [ -n "$VIRTUAL_ENV" ]; then
          venv="''${gry}(''${grn}''${VIRTUAL_ENV##*/}''${gry})''${rst} "
        fi

        # (rama) al principio, con ● si hay cambios sin commitear
        local git="" br dirty=""
        br=$(git symbolic-ref --short HEAD 2>/dev/null || git rev-parse --short HEAD 2>/dev/null)
        if [ -n "$br" ]; then
          [ -n "$(git status --porcelain 2>/dev/null)" ] && dirty=" ''${ylw}●"
          git="''${pur}(''${br})''${dirty}''${rst} "
        fi

        # Símbolo según el resultado del último comando
        local sym status=""
        if [ "$exit" -eq 0 ]; then
          sym="''${grn}❯"
        else
          sym="''${red}❯"
          status=" ''${red}✘ $exit"
        fi

        PS1="\n''${venv}''${git}''${bld}''${grn}\u''${gry}@''${blu}\h''${rst} ''${bld}''${blu}\w''${rst}''${status}''${rst}\n''${bld}''${sym}''${rst} "
      }

      __bash_history_log() {
        local cmd
        cmd=$(fc -ln -1 2>/dev/null | sed -e 's/^[[:space:]]*//')
        [ -z "$cmd" ] && return
        if [ "$cmd" != "$__bash_history_last_cmd" ]; then
          __bash_history_last_cmd="$cmd"
          printf '[%s] %s\n' "$(date '+%d/%m/%Y %H:%M:%S')" "$cmd" >> "$HOME/.bash_history"
        fi
      }

      # __set_prompt primero, para leer bien el $? del comando anterior
      PROMPT_COMMAND="__set_prompt; __bash_history_log"

      bind 'TAB: menu-complete'
      bind '"\e[Z": menu-complete-backward'
      bind 'set menu-complete-display-prefix on'
      bind 'set show-all-if-ambiguous on'

      alias r="~/scripts/music.sh"
    '';
  };
}
