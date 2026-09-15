{ config, pkgs, ... }:

{
  programs.bash = {
    completion.enable = true;

    interactiveShellInit = ''
      # Historial con fecha y hora
      # Bash gestiona su propio historial "en crudo" (para las flechas arriba/abajo)
      # en un fichero separado, para no chocar con el formato personalizado que
      # escribimos nosotros mismos en ~/.bash_history
      export HISTFILE="$HOME/.bash_history_raw"
      export HISTSIZE=5000
      export HISTFILESIZE=5000
      export HISTCONTROL=ignoredups
      export HISTTIMEFORMAT="%d/%m/%Y %T  "

      # Cada vez que se ejecuta un comando, lo añadimos a ~/.bash_history
      # con el formato: [dd/mm/aaaa HH:MM:SS] comando
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

      # Tab: en vez de solo listar, cicla por las opciones (Shift+Tab para ir hacia atrás)
      bind 'TAB: menu-complete'
      bind '"\e[Z": menu-complete-backward'
      bind 'set menu-complete-display-prefix on'
      bind 'set show-all-if-ambiguous on'

      # Rama de git en el prompt
      source ${pkgs.git}/share/git/contrib/completion/git-prompt.sh
      export GIT_PS1_SHOWDIRTYSTATE=1
      PS1='\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[01;33m\]$(__git_ps1 " (%s)")\[\033[00m\]\$ '
    '';
  };
}
