# Make sure ENV settings are set for each bash subshell
#echo "enter .bashrc "

#BASH_SOURCE is a better guess as to the location of this script,
# but will only exist if bash version >=3
DOT_HOME=$(dirname "${BASH_SOURCE:-${HOME}/.bashrc}")
#echo ".bashrc: DOT_HOME=$DOT_HOME"
#echo "home is $HOME"

if [ -r "${DOT_HOME}/.profile" ]; then
#Make sure we include sh/ksh/bash common settings, even when sourcing this .bashrc from a different user
  . "${DOT_HOME}/.profile"
fi

xt(){
  xterm -r -sb -j -sk -si -sl 10000 -geom 120x80 $@ &
}

#are we an interactive shell?
if [ "$PS1" ]; then
  shopt -s checkwinsize
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
  xterm_titlebar='\[\e]0;\u@\h:\w\a'

# This first part of prompt will be shown in red for the root user, 
# green otherwise.
# Computing the root user color within the prompt slows down prompt rendering, but it allows the user to su to root and get a valid colored prompt without needing to re-source .bashrc 
  base_prompt='\n\e[$(( ($(id | cut -d= -f2 | cut -d\( -f1)==0) ? 31 : 32))m\# \j [\d \t] ${DISPLAY} \u@\e[${COLOR}m\h \e[0;33m${DIRSTACK[0]}\e[0m \e[34m${DIRSTACK[@]:1}\e[0m\n\$ '
  case "$TERM" in
    xterm*|dtterm*|terminator)
      PS1=${xterm_titlebar}${base_prompt}
      ;;
    *)
      PS1=${base_prompt}
      ;;
  esac
fi 
#echo "exit .bashrc"
