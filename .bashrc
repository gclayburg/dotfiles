# Make sure ENV settings are set for each bash subshell
#set -x
#echo "enter .bashrc "

RUNDIR=$(dirname "${BASH_SOURCE:-$HOME}")
UNQUALIFIED_HOSTNAME=$(echo $HOSTNAME | cut -d. -f1)

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
    alias more=/usr/xpg4/bin/more
    ;;
  CYGWIN) #Win XP, 2000, NT, Vista?
    #Windows XP/Cygwin reports $0 as "-sh" when invoking !ls from ftp server 
    if [ $0 != "sh" -a $0 != "-sh" ]; then
      alias more=less
      alias mroe=less
    fi
# 11/3/2011 who command does not work on cygwin running on windows 7? - it returns no output
    if [ $(who -m | wc -l ) -gt 0 ]; then
      LOGINFROM=$(who -m | sed 's/.*(\(.*\))/\1/g')
    else
      LOGINFROM=":0"
    fi

    #start up ssh-agent for the first terminal window opened under cygwin
    if [ "$LOGINFROM" = ":0" -a "$PS1" ]; then  #skip somewhat slow ssh-agent check if we are not logged onto the console
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
  alias which='type -a'  # More helpful which

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
    # http://ascii-table.com/ansi-escape-sequences.php
    # https://wiki.archlinux.org/index.php/Color_Bash_Prompt

    # regular colors
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
    local RED_ON_GREEN='\e[31;1;42m'
    local RED_ON_BROWN='\e[31;1;43m'
    local  RED_ON_BLUE='\e[31;1;44m'
    local BLUE_ON_WHITE='\e[47;1;34m'
    local YELLOW_ON_BLACK='\e[40;1;33m'
    local HOSTCOLOR


    case "`uname -s | cut -d_ -f1`" in
      Linux)
        HOSTCOLOR=${B_DARK_GRAY}  #default color if lsb_release not installed
        LSB_RELEASE=$(lsb_release -i 2> /dev/null | cut -d: -f2 | sed s/'^\t'//)
        if [[ ! -z $LSB_RELEASE ]]; then
          case "$LSB_RELEASE" in
            Ubuntu)
              HOSTCOLOR=${RED_ON_BROWN}
              ;;
            CentOS | RedHat)
              HOSTCOLOR=${B_RED}
              ;;
            LinuxMint)
              HOSTCOLOR=${RED_ON_GREEN}
              ;;
            *)
              HOSTCOLOR=${RED_ON_BLUE}
              ;;
          esac
        fi
        ;;
      SunOS)
        case "`uname -p`" in
          sparc)
            HOSTCOLOR=${BLUE_ON_WHITE}
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

# if status of last command is non-zero, print it out prominently in yellow on red
    local p_exit_status='$(last_stat=$?;if [ $last_stat -ne 0 ]; then echo "\e[41;1;33m${last_stat}\e[0m "; fi)'

# This first part of prompt will be shown in red for the root user, 
# green otherwise.
    local rootColor='$((  (${EUID}==0) ? 31 : 32))'
    local p_userColor="\e[${rootColor}m"
    local p_jobs="\! \j "
    local p_datetime="[\d \t] " #safe even for old versions of bash
    if (( ${BASH_VERSINFO} >= 3)); then # trim down length of date display for recent versions of bash that support \D
       p_datetime="[\D{%m-%d} \t] "
    fi

    local p_display='${DISPLAY:+$DISPLAY }\u@'  #pad $DISPLAY with one space at the end, if DISPLAY is set
    local p_host="${HOSTCOLOR}\h"

    #dash shell is confused by DIRSTACK
    local p_pwd="${YELLOW} "'$(if [ -n ${BASH_VERSION} ]; then echo ${DIRSTACK[0]}; else echo $PWD; fi)'
    # show directory stack in green, as long as PS1 is being evaluated by bash
    local p_dirstack=" ${GREEN}"'$(if [ -n ${BASH_VERSION} ]; then echo ${DIRSTACK[@]:1}; else echo ""; fi)'
    # " (master)", when in git master branch
    local p_gitbranch="${BLUE}"'$(git branch 2> /dev/null | sed -e "/^[^*]/d" -e "s/* \(.*\)/ (\1)/" )'

    local p_ending="${OFF}"'\n\$ '

    #display identities held by ssh-agent for this session
    local p_sshagentkeys=$(ssh-add -l 2> /dev/null | cut -d\( -f2 | cut -d\) -f1 | tr '\n' ' ')

    local base_prompt='\n'
    base_prompt=${base_prompt}${p_exit_status}
    base_prompt=${base_prompt}${p_userColor}
    base_prompt=${base_prompt}${p_jobs}
    base_prompt=${base_prompt}${p_datetime}
    base_prompt=${base_prompt}${p_sshagentkeys}
    base_prompt=${base_prompt}${p_display}
    base_prompt=${base_prompt}${p_host}
    base_prompt=${base_prompt}${p_gitbranch}
    base_prompt=${base_prompt}${p_pwd}
    base_prompt=${base_prompt}${p_dirstack}
    base_prompt=${base_prompt}${p_ending}

# Does our terminal know how to handle setting the title bar?
    case "$TERM" in
      xterm*|dtterm*|terminator|rxvt*)
        PS1=${xterm_titlebar}${base_prompt}
        ;;
      *)
        PS1=${base_prompt}
        ;;
    esac

    #exporting PS1 is helpful when doing things like:
    # sudo bash
    # sudo sh
    # su
    export PS1
    alias sh="PS1='\$0 $USER@$HOSTNAME \$ ' sh"  # use very minimal prompt for sh subshells
    alias dash="PS1='\$0 $USER@$HOSTNAME \$ ' dash"  # use very minimal prompt for sh subshells
  }
  setPrompt
  unset -f setPrompt
fi 
#echo "exit .bashrc"

#localhost overrides
if [[ -f ${RUNDIR}/.bashrc.${UNQUALIFIED_HOSTNAME} ]]; then
  source ${RUNDIR}/.bashrc.${UNQUALIFIED_HOSTNAME}
elif [[ -f ${RUNDIR}/.bashrc.localhost ]]; then
  source ${RUNDIR}/.bashrc.localhost
fi
