## Make sure ENV settings are set for each bash subshell
#set -x
#echo "enter .bashrc "

RUNDIR=$(dirname "${BASH_SOURCE:-$HOME}")
UNQUALIFIED_HOSTNAME=$(echo $HOSTNAME | cut -d. -f1)

# Source global definitions
if [ -f /etc/bashrc ]; then
        . /etc/bashrc
fi

# OS/shell common settings
# some systems do not put directories like /usr/sbin in the PATH.  Here,
# we just add everything.  Some directories in PATH may be duplicated.
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
    if [[ -d /usr/X11R6/man ]]; then
      MANPATH=${MANPATH}:/usr/X11R6/man
    fi
    export PATH MANPATH
    #Opinionated JAVA_HOME finder
    #Don't rely on someone having setup /etc/alternatives.
    # We prefer Sun/Oracle JVM for greatest compatibility, if installed
#    if [[ -d /usr/java/latest/ ]]; then #rpm style
#      JAVA_HOME=${JAVA_HOME:-/usr/java/latest/}
#    elif [[ -d /usr/lib/jvm/java-8-oracle/ ]]; then #deb style
#      JAVA_HOME=${JAVA_HOME:-/usr/lib/jvm/java-8-oracle/}
#    elif [[ -d /usr/lib/jvm/java-7-oracle/ ]]; then
#      JAVA_HOME=${JAVA_HOME:-/usr/lib/jvm/java-7-oracle/}
#    elif [[ -d /usr/lib/jvm/default-java/ ]]; then
#      JAVA_HOME=${JAVA_HOME:-/usr/lib/jvm/default-java/}
#    fi

    #build JAVA_HOME from javac:
    if [[ -e /usr/bin/javac ]]; then
      JAVA_HOME=$(readlink -f /usr/bin/javac | sed "s:bin/javac::")
    fi
    if [[ -n "$JAVA_HOME" ]]; then
      export JAVA_HOME
      PATH=${JAVA_HOME}/bin:$PATH
    fi
    if [[ -d /usr/X11R6/bin/ ]]; then  #X programs on older systems
      PATH=${PATH}:/usr/X11R6/bin/
    fi
    alias ls='ls -F --color=tty'
    if [ -r /usr/bin/firefox ]; then
      export BROWSER=/usr/bin/firefox
    fi

    # make less more friendly for non-text input files
    if [ -x /usr/bin/lesspipe ]; then
      #try asking this lesspipe to setup itself (works on ubuntu)
      if ! eval "$(SHELL=/bin/sh lesspipe)" 2>/dev/null; then
        #assume this lesspipe can be used this way (works on coreos)
        #apparently the lesspipe on coreos will not provide hints to setup itself
        export LESSOPEN="|lesspipe %s"
      fi
    fi
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
    
    MANPATH=${MANPATH}:/usr/openwin/man:/usr/dt/share/man:/usr/local/man
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
      export SSH_AUTH_SOCK=/tmp/.ssh-socket
      export SSH_AUTH_SCRIPT=/tmp/.ssh-script
      if [[ -e $SSH_AUTH_SCRIPT ]]; then
        . $SSH_AUTH_SCRIPT > /dev/null #don't tell me the pid.  I got it.
      fi
      if  ! $(ps -p ${SSH_AGENT_PID} 1 | grep agent >/dev/null) ; then #ssh-agent is not running
        echo "starting ssh-agent..."
        rm -f $SSH_AUTH_SOCK
        rm -f $SSH_AUTH_SCRIPT
        ssh-agent -a $SSH_AUTH_SOCK > $SSH_AUTH_SCRIPT
        . $SSH_AUTH_SCRIPT
        ssh-add #login required if passphrase is set on any private keys
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

  alias ssh='ssh -A'  #single sign-on

  # number of commands to remember in the command history
  HISTSIZE=10000
  # The maximum number of commands to remember in the history file
  HISTFILESIZE=50000

  FCEDIT=vi

  installidusage(){
    echo "usage: installid [user@]hostname"
    echo "usage examples:"
    echo
    echo "install my public key into the gclaybur user on host ogre:"
    echo "  installid gclaybur@ogre"
    echo
    echo "install my public key into the $USER user on host evans.example.com:"
    echo "  installid evans.example.com"
    }

  installid(){  #install my public key on to another host to enable SSO
    PUBLIC_KEY=$(ssh-add -L | head -1)
    status=$?
    if [[ -n ${PUBLIC_KEY} ]]; then #use public key from ssh agent

      echo "$PUBLIC_KEY" | ssh "$1" "if [[ ! -d .ssh ]]; then mkdir .ssh; chmod 700 .ssh; fi; cat >> .ssh/authorized_keys"
      status=$?
    else #try to use public key created on this host
      if [[ -r "$HOME/.ssh/id_rsa.pub" ]]; then
        PUBLIC_KEY="$HOME/.ssh/id_rsa.pub";
      elif [[ -r "$HOME/.ssh/id_dsa.pub" ]]; then
        PUBLIC_KEY="$HOME/.ssh/id_dsa.pub";
      else
        echo "No ssh key found. Please use ssh-keygen manually to generate public/private keypair  OR"
        echo "re-execute this command after logging on to this host with SSH keys"
        return 99
      fi
      cat "$PUBLIC_KEY" | ssh "$1" "if [[ ! -d .ssh ]]; then mkdir .ssh; chmod 700 .ssh; fi; cat >> .ssh/authorized_keys"
      status=$?
    fi
    if [[ "$status" != "0" ]]; then
      installidusage
    else
      ASSIMILATED_HOSTS="$HOME/.ssh/assimilated_hosts"
      if [[ ! (-f ${ASSIMILATED_HOSTS}) ]]; then
        echo "# This is a generated list of known places where this user can login with public key\n" >> ${ASSIMILATED_HOSTS}
      fi
      echo "$1" >> ${ASSIMILATED_HOSTS};
    fi
  }

  go(){
    echo "--> $*"
    eval $*
  }

  pushdotfiles(){
    BACKUPDIR=.dotfiles.backedup.$(date "+%Y-%m-%d_%H-%M-%S")
    echo "$1" | grep : > /dev/null
    if [ "$?" == "0" ]; then # assume $1 is of the form: rbeatty@jaxaf2661:gclaybur/
      USER_DIR="$1"
      USER_SPEC=$(echo "$1" | cut -d: -f1)
      USER_HIJACK=$(echo "$1" | cut -d: -f2)
      go ssh ${USER_SPEC} "mkdir $USER_HIJACK"
    else  #append : to specify home directory of user on remote host
      USER_DIR="$1":
    fi
    #backup any previous dotfiles
    go ssh $1 "mkdir $BACKUPDIR"
    sshstatus=$?

    if [[ $sshstatus != 0 ]] ; then
      echo "$1 down?"
      return $sshstatus
    fi
    go ssh $1 "cp -p .bash\* .prof\* .dir_colors .inputrc ${BACKUPDIR}/"
    go scp -rp .bash_login .bashrc .profile .dir_colors .inputrc "${USER_DIR}"
  }


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
    local RED_UNDERLINE='\e[4;31m'
    local RED_ON_GREEN='\e[31;1;42m'
    local RED_ON_BROWN='\e[31;1;43m'
    local  RED_ON_BLUE='\e[31;1;44m'
    local  RED_ON_GRAY='\e[31;1;47m'
    local BLUE_ON_WHITE='\e[47;1;34m'
    local YELLOW_ON_BLACK='\e[40;1;33m'
    local HOSTCOLOR


    case "`uname -s | cut -d_ -f1`" in
      Linux)
        HOSTCOLOR=${RED_UNDERLINE}  #default color if lsb_release not installed
        LSB_RELEASE=$(lsb_release -i 2> /dev/null | cut -d: -f2 | sed s/'^\t'//)
        if [[ ! -z $LSB_RELEASE ]]; then
          case "$LSB_RELEASE" in
            Ubuntu | LinuxMint)
              HOSTCOLOR=${RED_ON_BROWN}
              ;;
            CentOS | RedHat)
              HOSTCOLOR=${B_RED}
              ;;
            *)
              HOSTCOLOR=${RED_ON_BLUE}
              ;;
          esac
        elif [[ -e /etc/redhat-release ]]; then
          HOSTCOLOR=${B_RED}
        elif [[ -f /etc/os-release ]]; then
          #/etc/coreos/update.conf  for channel: alpha,beta,stable
          CoreOSname=$(grep "^NAME" /etc/os-release | cut -d"=" -f2)
          if [[ "$CoreOSname" =~ ^CoreOS ]]; then
            HOSTCOLOR=${RED_ON_GRAY}
          fi
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
    local p_gitbranch=""
    if [[ $(git --version 2> /dev/null) ]]; then
      #only evaluate git branch info if git is installed on this box
      #without this check, prompt rendering will slow down on boxes like ubuntu that spit out verbose info if git is not installed
      p_gitbranch="${BLUE_ON_WHITE}"'$(git branch 2> /dev/null | sed -e "/^[^*]/d" -e "s/* \(.*\)/(\1)/" )'
    fi

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
    base_prompt=${base_prompt}${OFF}" "
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
