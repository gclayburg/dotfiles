# Make sure ENV settings are set for each bash subshell
#echo "enter .bashrc "

#BASH_SOURCE is a better guess as to the location of this script,
# but will only exist if bash version >=3
DOT_HOME=$(dirname ${BASH_SOURCE:-${HOME}/.bashrc})
#echo ".bashrc: DOT_HOME=$DOT_HOME"
#echo "home is $HOME"

if [ -r "${DOT_HOME}/.profile" ]; then
  . "${DOT_HOME}/.profile"
fi
xt(){
  xterm -r -sb -j -sk -si -sl 10000 -geom 120x80 $@ &
}
#are we an interactive shell?
if [ "$PS1" ]; then
  shopt -s checkwinsize

  #bash shell specific
  #PROMPT_COMMAND='/usr/bin/echo ;dirs | cut -s -d" " -f2-'  #spit out dirs in the stack
  #PROMPT_COMMAND="${HOME}/.prompt_command"  #spit out dirs in the stack
  case "`uname -s | cut -d_ -f1`" in
    Linux)
      COLOR=1\;31  #Red
      ;;
    SunOS)
      case "`uname -p`" in
        sparc)
          COLOR=1\;34  #dark blue
          ;;
        i386)
          COLOR=1\;32  #green
          ;;
        *) # should not happen
          COLOR=1\;35  #purple
          ;;
      esac
      ;;
    AIX)
      COLOR=1\;35 #purple
      ;;
    HP-UX)
      COLOR=1\;37  #white
      ;;
    CYGWIN)
      COLOR=1\;36  #cyan
      ;;
    *)
      COLOR=1\;30  #dark gray
      ;;
  esac
  export COLOR
  USERCOLOR=$(( (`id | cut -d= -f2 | cut -d\( -f1`==0) ? 31 : 32))
  export USERCOLOREXEC='$(( ($(id | cut -d= -f2 | cut -d\( -f1)==0) ? 31 : 32))'

  #PS1='\[\e]0;\u@\h:\w\a\e[32m\]\# \j [\d \t] ${DISPLAY} \u@\e[${COLOR};40m\h \[\e[33m\w\e[0m\]\n\$ '
  #PS1='\n\[\e]0;\u@\h:\w\a\e[32m\]\# \j [\d \t] ${DISPLAY} \u@\e[${COLOR};40m\h \[\e[33m${DIRSTACK[*]}\e[0m\]\n\$ '
  xterm_titlebar='\[\e]0;\u@\h:\w\a'
  #base_prompt='\n\e[32m\]\# \j [\d \t] ${DISPLAY} \u@\e[${COLOR};40m\h \[\e[33m${DIRSTACK[0]}\e[0m\] \e[37m${DIRSTACK[@]:1}\e[0m\]\n\$ '

  #base_prompt='\n\e[$(USERCOLOR)m\]\# \j [\d \t] ${DISPLAY} \u@\e[${COLOR}m\h \[\e[0;33m${DIRSTACK[0]}\e[0m\] \e[37m${DIRSTACK[@]:1}\e[0m\]\n\$ '

  #Computing the color within the prompt slows down prompt rendering, but it allows the user to su to root and get a valid colored prompt without needing to . .bashrc
  base_prompt='\n\e[$(( ($(id | cut -d= -f2 | cut -d\( -f1)==0) ? 31 : 32))m\# \j [\d \t] ${DISPLAY} \u@\e[${COLOR}m\h \e[0;33m${DIRSTACK[0]}\e[0m\] \e[37m${DIRSTACK[@]:1}\e[0m\n\$ '
  case "$TERM" in
    xterm*|dtterm*)
      #PS1='\n\[\e]0;\u@\h:\w\a\e[32m\]\# \j [\d \t] ${DISPLAY} \u@\e[${COLOR};40m\h \[\e[33m${DIRSTACK[0]}\e[0m\] \e[37m${DIRSTACK[@]:1}\e[0m\]\n\$ '
      PS1=${xterm_titlebar}${base_prompt}
      ;;
    *)
      PS1=${base_prompt}
      ;;
  esac
fi 
#echo "exit .bashrc"
