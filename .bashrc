# Make sure ENV settings are set for each bash subshell
#echo "enter .bashrc "

#BASH_SOURCE is a better guess as to the location of this script,
# but will only exist if bash version >=3
DOT_HOME=$(dirname "${BASH_SOURCE:-${HOME}/.bashrc}")
#echo ".bashrc: DOT_HOME=$DOT_HOME"
#echo "home is $HOME"

if [ -r "${DOT_HOME}/.profile" ]; then
#Make sure we include sh/ksh/bash common settings, even when sourcing this .bashrc from a different user
#We also get platform specific settings and overrides, i.e. isRoot()
  . "${DOT_HOME}/.profile"
fi

xt(){
  xterm -r -sb -j -sk -si -sl 10000 -geom 120x80 $@ &
}

setWindowTitle() {
  echo -ne "\e]0;$*\a"
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
# Computing the root user color within the prompt slows down prompt rendering, 
#   but it allows the user to su to root and get a valid colored prompt without needing to re-source .bashrc 
  
# regular colors
  K="\[\033[0;30m\]"    # black
  R="\[\033[0;31m\]"    # red
  G="\[\033[0;32m\]"    # green
  Y="\[\033[0;33m\]"    # yellow
  B="\[\033[0;34m\]"    # blue
  M="\[\033[0;35m\]"    # magenta
  C="\[\033[0;36m\]"    # cyan
  W="\[\033[0;37m\]"    # white
  OFF="\[\033[0m\]"

# if the -u option exists, id -u allows faster prompt rendering, esp on Cygwin
#  id -u > /dev/null 2>&1
#  if [ "$?" -eq "0" ]; then  
#    myColor='$(( ($(id -u)==0) ? 31 : 32))'
#    myColor='$((  ($EUID==0) ? 31 : 32))'
#  else
#    myColor='$(( ($(id | cut -d= -f2 | cut -d\( -f1)==0) ? 31 : 32))'
#    myColor='$(( ($(fastid=$(id) ; someid="${fastid#*=}" ; echo "${someid%%(*)}") ==0) ? 31 : 32))'
#    myColor='$((  ($EUID==0) ? 31 : 32))'
#  fi
    myColor='$((  ($EUID==0) ? 31 : 32))'
    userColorPrompt="\n\e[${myColor}m"
    base_prompt='\# \j [\d \t] ${DISPLAY} \u@\e[${COLOR}m\h \e[0;33m${DIRSTACK[0]}\e[0m \e[34m${DIRSTACK[@]:1}\e[0m\n\$ '
    base_prompt=${userColorPrompt}${base_prompt}
# Does our terminal know how to handle setting the title bar?
  case "$TERM" in
    xterm*|dtterm*|terminator|rxvt*)
      PS1=${xterm_titlebar}${base_prompt}
      ;;
    *)
      PS1=${base_prompt}
      ;;
  esac
fi 
#echo "exit .bashrc"
