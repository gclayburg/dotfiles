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


#are we an interactive shell?
if [ "$PS1" ]; then
  shopt -s checkwinsize
  #setWindowTitle() {
  #  echo -ne "\e]0;$*\a"
  #}

  setPrompt(){
    # regular colors
    local       K="\[\033[0;30m\]"    # black
    local   BLACK='\e[0;30m'
    local     RED='\e[0;31m'
    local   GREEN='\e[0;32m'
    local  YELLOW='\e[0;33m'
    local    BLUE='\e[0;34m'
    local MAGENTA='\e[0;35m'
    local    CYAN='\e[0;36m'
    local   WHITE='\e[0;37m'
    local     OFF='\e[0m'

    # bold colors
    local B_DARK_GRAY='\e[1;30m'
    local       B_RED='\e[1;31m'
    local     B_GREEN='\e[1;32m'
    local    B_YELLOW='\e[1;33m'
    local      B_BLUE='\e[1;34m'
    local   B_MAGENTA='\e[1;35m'
    local      B_CYAN='\e[1;36m'
    local     B_WHITE='\e[1;37m'
    local HOSTCOLOR
    case "`uname -s | cut -d_ -f1`" in
      Linux)
        HOSTCOLOR=${B_RED}
        ;;
      SunOS)
        case "`uname -p`" in
          sparc)
            HOSTCOLOR=${B_BLUE}
            ;;
          i386)
            HOSTCOLOR=${B_GREEN}
            ;;
          *) # should not happen
            HOSTCOLOR=${B_MAGENTA}
            ;;
        esac
        ;;
      AIX)
        HOSTCOLOR=${B_MAGENTA}
        ;;
      HP-UX)
        HOSTCOLOR=${B_WHITE}
        ;;
      CYGWIN)
        HOSTCOLOR=${B_CYAN}
        ;;
      *)
        HOSTCOLOR=${B_DARK_GRAY}
        ;;
    esac
    local xterm_titlebar='\[\e]0;\u@\h:\w\a'

# This first part of prompt will be shown in red for the root user, 
# green otherwise.
# Computing the root user color within the prompt slows down prompt rendering, 
#   but it allows the user to su to root and get a valid colored prompt without needing to re-source .bashrc 
  

# if the -u option exists, id -u allows faster prompt rendering, esp on Cygwin
#  id -u > /dev/null 2>&1
#  if [ "$?" -eq "0" ]; then  
#    rootColor='$(( ($(id -u)==0) ? 31 : 32))'
#    rootColor='$((  ($EUID==0) ? 31 : 32))'
#  else
#    rootColor='$(( ($(id | cut -d= -f2 | cut -d\( -f1)==0) ? 31 : 32))'
#    rootColor='$(( ($(fastid=$(id) ; someid="${fastid#*=}" ; echo "${someid%%(*)}") ==0) ? 31 : 32))'
#    rootColor='$((  ($EUID==0) ? 31 : 32))'
#  fi
    local rootColor='$((  ($EUID==0) ? 31 : 32))'
    local p_userColor='\n'"\e[${rootColor}m\# \j [\d \t] "
    local p_display='${DISPLAY} \u@'
    local p_host="${HOSTCOLOR}\h"
    local p_pwd=" ${YELLOW}"'${DIRSTACK[0]}'
    local p_dirstack=" ${BLUE}"'${DIRSTACK[@]:1}'
    local p_ending="${OFF}"'\n\$ '
    local base_prompt=${p_userColor}${p_display}${p_host}${p_pwd}${p_dirstack}${p_ending}
# Does our terminal know how to handle setting the title bar?
    case "$TERM" in
      xterm*|dtterm*|terminator|rxvt*)
        PS1=${xterm_titlebar}${base_prompt}
        ;;
      *)
        PS1=${base_prompt}
        ;;
    esac
    export PS1
  }
  setPrompt
  unset setPrompt
fi 
#echo "exit .bashrc"
