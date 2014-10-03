# Make sure ENV settings are set for each bash subshell
#set -x
#echo "enter .bashrc "

RUNDIR=$(dirname "${BASH_SOURCE:-$HOME}")
UNQUALIFIED_HOSTNAME=$(echo $HOSTNAME | cut -d. -f1)
#echo "RUNDIR: $RUNDIR"
#echo "bash source: $BASH_SOURCE"
# Source global definitions
if [ -f /etc/bashrc ]; then
        . /etc/bashrc
fi

# OS/shell common settings
PATH=/usr/bin:\
/bin:\
/usr/sbin:\
/sbin:\
/etc:\
/usr/local/bin:\
$HOME/bin:\
.:\
$PATH

LD_LIBRARY_PATH=/usr/lib
export LD_LIBRARY_PATH

MANPATH=/usr/share/man
PROFILE=true
EDITOR=vi
VISUAL=vi
PAGER=less
LANG=C

#include (){
#  if [ -r "$1" ]; then
#    . "$1" fi
#}


case "`uname -s | cut -d_ -f1`" in
  Linux)
    if [[ -f ${RUNDIR}/.bashrc.${UNQUALIFIED_HOSTNAME} ]]; then
      source ${RUNDIR}/.bashrc.${UNQUALIFIED_HOSTNAME}
    fi
    MANPATH=${MANPATH}:/usr/share/man:/usr/X11R6/man
    export PATH MANPATH
    JAVA_HOME=${JAVA_HOME:-/usr/java/latest/}
    export JAVA_HOME
    PATH=${JAVA_HOME}/bin:\
${PATH}:\
/usr/X11R6/bin/
    alias ls='ls -F --color=tty'
    if [ -r /usr/bin/firefox ]; then
      export BROWSER=/usr/bin/firefox
    fi
    #oracle XE
    if [ -d /usr/lib/oracle/xe/app/oracle/product/10.2.0/server ]; then
      export ORACLE_HOME=/usr/lib/oracle/xe/app/oracle/product/10.2.0/server
      export PATH=$PATH:$ORACLE_HOME/bin
      export ORACLE_SID=XE
    fi
  # make less more friendly for non-text input files
  [ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"


    ;;
  SunOS)
    PATH=${PATH}:\
/usr/ucb:\
/etc:\
/usr/openwin/bin:\
/usr/dt/bin:\
/usr/ccs/bin:\
/usr/ucb/bin:\
/usr/local/sbin
    
    ###########################
    if [ ! "${DT}" ] ; then  #what the?
            #stty erase 
            TTY=`tty | sed -e 's,.*/,,'`
    fi
    
    MANPATH=${MANPATH}:/usr/share/man:/usr/openwin/man:/usr/dt/share/man:/usr/local/man
    export PATH MANPATH
    JAVA_HOME=/usr/java1.2
    export JAVA_HOME
    alias more=/usr/xpg4/bin/more
    
    #################################################################
    # JWhich CLASSPATH
    CLASSPATH=$CLASSPATH:~/classes
    export CLASSPATH
    ;;
  CYGWIN) #Win XP, 2000, NT, Vista?
    #Windows XP/Cygwin reports $0 as "-sh" when invoking !ls from ftp server 
    if [ $0 != "sh" -a $0 != "-sh" ]; then
      alias more=less
      alias mroe=less
    fi
# 11/3/2011 who commnad does not work on cygwin running on windows 7? - it returns no output
    if [ $(who -m | wc -l ) -gt 0 ]; then
    LOGINFROM=$(who -m | sed 's/.*(\(.*\))/\1/g')
    else
      LOGINFROM=":0"
    fi

    if [ "$LOGINFROM" = ":0" ]; then  #skip somewhat slow ssh-agent check if we are not logged onto the console
        export SSH_AUTH_SOCK=/tmp/.ssh-socket-gary
        ssh-add -l #2>&1 > /dev/null
        mystatus=$?
        echo "ssh-add status: $mystatus"
        if [ $mystatus -eq 2 ]; then
          # ssh-agent is not running, start it
          echo "\$ ssh-agent -a $SSH_AUTH_SOCK > /tmp/.ssh-script-gary"
          rm -f $SSH_AUTH_SOCK
          ssh-agent -a $SSH_AUTH_SOCK > /tmp/.ssh-script-gary
          #sleep 10
          . /tmp/.ssh-script-gary
          echo $SSH_AGENT_PID > /tmp/.ssh-agent-pid
          echo "started agent"
          ssh-add
        fi
    fi
    case "`uname -n`" in
      DellE1705GaryC)

#export JAVA_HOME=/c/j2sdk1.4.1
#export JAVA_HOME="/c/Program Files/Java/jdk1.5.0"
#export JAVA_HOME="/c/Program Files/Java/jdk1.6.0"
#export JAVA_HOME="/c/Sun/SDK/jdk"

#penrose server vd-server.bat needs JAVA_HOME set for running via rxvt/bash
export JAVA_HOME="c:\Sun\SDK\jdk"
#export ANT_HOME=/c/jakarta/jakarta-ant-1.5.1
#export ANT_HOME=/c/jakarta/apache-ant-1.6.2
export ANT_HOME=/c/jakarta/apache-ant-1.8.0RC1


export CLASSPATH="${CLASSPATH};c:\\api\\jwhich"

MANPATH=${MANPATH}:/usr/man:/usr/ssl/man:/usr/X/man
export MANPATH

PATH=${ANT_HOME}/bin:$PATH
#        PATH=$(cygpath --unix "${JAVA_HOME}/bin"):$PATH
PATH="/c/Gary/bin:$PATH"
export DISPLAY=localhost:0

###############################
# Python
PATH="/c/Python23:$PATH"

export CVSROOT=/c/Gary/cvs

export AXIS2_HOME="/c/apache/axis2-1.5.1/"
PATH="${AXIS2_HOME}/bin:${PATH}"

##############################
# Maven
M2_HOME=/c/apache/apache-maven-2.2.1/
M2=${M2_HOME}/bin
#MAVEN_OPTS= -Xms256m -Xmx512m
PATH="${M2}:${PATH}"

##############################
# SpringSource Roo

export ROO_HOME=/c/api/spring-roo-1.0.2.RELEASE
PATH="${ROO_HOME}/bin:${PATH}"

##############################
# Canoo WebTest
PATH="${PATH}:/c/api/WebTest-canoo/bin"

########################
# WinMerge
PATH="${PATH}:/c/Program Files/WinMerge"
        ;;
      MININT-VCQU7PL)
        #export JAVA_HOME='c:\Program Files\Java\jdk1.6.0_30\'
        export JAVA_HOME='c:\Program Files\Java\jdk1.7.0_01'
        export ANT_HOME=/c/api/apache-ant-1.8.2
        PATH=${ANT_HOME}/bin:$PATH
        M2_HOME=/c/api/apache-maven-3.0.3/
        M2=${M2_HOME}/bin
        #MAVEN_OPTS= -Xms256m -Xmx512m
        PATH="${M2}:${PATH}"
        ;;
    esac
    PATH=$(cygpath --unix "${JAVA_HOME}/bin"):$PATH
    ;;
  HP-UX) 
    # enter HP-UX specific .profile settings here
    ;;
  AIX)  #AIX
    #####################
    # ibm apache web server
    PATH=${PATH}:/opt/ibmhttpd/bin

    PATH=${PATH}:/opt/freeware/bin
    PATH=/opt/IBM/ldap/V6.1/bin:/opt/IBM/ldap/V6.1/sbin:${PATH}
    export JAVA_HOME=/usr/java14
    if [ -d /usr/java6_64 ]; then
      export JAVA_HOME=/usr/java6_64
    elif [ -d /usr/java5 ]; then
      export JAVA_HOME=/usr/java5
    elif [ -d /opt/IBM/ldap/V6.1/java ]; then
      export JAVA_HOME=/opt/IBM/ldap/V6.1/java
    elif [ -d /usr/java14 ]; then
      export JAVA_HOME=/usr/java14
    elif [ -d /web/WebSphere61/AppServer/java ]; then
      export JAVA_HOME=/web/WebSphere61/AppServer/java
    elif [ -d /web/WebSphere/AppServer/java ]; then
      export JAVA_HOME=/web/WebSphere/AppServer/java
    fi
    PATH=${JAVA_HOME}/bin:${PATH}

    if [ -d /tomcat/apache-ant-1.7.0 ]; then
      export ANT_HOME=/tomcat/apache-ant-1.7.0
    elif [ -d /opt/apache-ant-1.7.1 ]; then
      export ANT_HOME=/opt/apache-ant-1.7.1
    fi
    PATH=${PATH}:${ANT_HOME}/bin
    CATALINA_HOME=

    ulimit -d unlimited
    include "${PROFILE_HOME}/.profile_aix"
    include "${PROFILE_HOME}/.profile_aix_${MY_HOST}"

    #some AIX boxes do not have less installed
    PAGER=more
    less -V > /dev/null 2>&1
    [ "$?" == "0" ] && PAGER=less || alias less=more

    MANPATH=$MANPATH:/usr/local/man:/usr/local/man/man1:/usr/local/man/man3:/usr/local/man/man5:/usr/local/man/man8

    ;;
  *)
    ;;
esac

setDirColors(){
  #use color ls when available, i.e. linux/cygwin, others?
  ls --color=tty > /dev/null 2>&1
  if [ "$?" -eq "0" ]; then
    alias ls='ls -F --color=tty'
    local MY_BASH=${BASH_SOURCE:-${HOME}/.bashrc}
    local dir=$(dirname "$MY_BASH")
    eval "`dircolors -b ${dir}/.dir_colors  2> /dev/null`"
  fi
}
setDirColors
unset -f setDirColors



#6/3/2011 - if ENV is uncommented, some AIX systems will display man pages with short column widths when this .bashrc is sourced from another user such as wicaadm
#ENV=$HOME/.profile

export FCEDIT PROFILE EDITOR VISUAL PAGER HOSTNAME PATH MANPATH HISTFILE HISTSIZE ENV LANG
#are we an interactive shell?
if [ "$PS1" ]; then
  set -o emacs

  #stupid finger patch
  alias mroe=more
  alias gerp=grep
  alias grpe=grep
  alias duf='du -sk * | sort -nr | perl -ne '\''($s,$f)=split(m{\t});for (qw(K M G)) {if($s<1024) {printf("%.1f",$s);print "$_\t$f"; last};$s=$s/1024}'\'''


  # number of commands to remember in the command history
  HISTSIZE=10000
  # The maximum number of commands to remember in the history file
  HISTFILESIZE=50000

  FCEDIT=vi


  #allow bash to resize screen area when terminal window size changes
  shopt -s checkwinsize

  #allow C-s (forward search to work in shell)
  stty stop undef


#------------------------------------------------------------------------------------------
# INCREMENTAL HISTORY SEARCH
# "Add this to your .bashrc and you will be very happy" by Jeet
#------------------------------------------------------------------------------------------

## Up Arrow: search and complete from previous history
# bind '"\eOA": history-search-backward'
## alternate, if the above does not work for you:
bind '"\e[A":history-search-backward'
bind '"\C-p":history-search-backward'

## Down Arrow: search and complete from next history
# bind '"\eOB": history-search-forward'
## alternate, if the above does not work for you:
bind '"\e[B":history-search-forward'
bind '"\C-n":history-search-forward'


  #setWindowTitle() {
  #  echo -ne "\e]0;$*\a"
  #}

  xt(){
    xterm -r -sb -j -sk -si -sl 10000 -geom 120x80 $@ &
  }
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
    local WHITE_B_BLUE='\e[47;1;34m'
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
            HOSTCOLOR=${WHITE_B_BLUE}
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
#   local rootColor='$((  ($EUID==0) ? 31 : 32))'
    local rootColor='$((  (${EUID:=1234}==0) ? 31 : 32))'
    local p_userColor='\n'"\e[${rootColor}m\# \j [\d \t] "
    local p_display='${DISPLAY} \u@'
    local p_host="${HOSTCOLOR}\h"
    local p_pwd=" ${YELLOW}"'${DIRSTACK[0]}'
    local p_dirstack=" ${GREEN}"'${DIRSTACK[@]:1}'
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

    #exporting this PS1 confuses dash - it goes into an infinite loop when dash is invoked
    #   from a bash shell, i.e. on ubuntu systems  /bin/sh -> dash
    #export PS1
  }
  setPrompt
  unset -f setPrompt
fi 
#echo "exit .bashrc"


