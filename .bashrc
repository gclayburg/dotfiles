## Make sure ENV settings are set for each bash subshell
#set -x
#echo "enter .bashrc with PATH $(echo $PATH | tr ':' '\n')"

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac



#RUNDIR=$(dirname "${BASH_SOURCE:-$HOME}")
RUNDIR="$( cd "$( dirname "${BASH_SOURCE[0]:-$HOME}" )" && pwd )"
UNQUALIFIED_HOSTNAME=$(echo "$HOSTNAME" | cut -d. -f1)

# Source global definitions
if [ -f /etc/bashrc ]; then
        . /etc/bashrc
fi

# OS/shell common settings
# some older systems do not put directories like /usr/sbin in the PATH.
# we want to add these only if they do not already exist in PATH
# otherwise, each subshell will create more duplicate entries in PATH
# these dups can confuse some interactive tools like nvm that also manipulate PATH

#add PATH entires to front of PATH, no dups
for pathentry in $HOME/.local/bin $HOME/bin /usr/local/bin /sbin /usr/sbin /usr/bin /bin; do
  case ":$PATH:" in
    *":$pathentry:"*) :;; # do nothing, already there
    *) PATH="$pathentry:$PATH";;
  esac
done

#add PATH entries to end of PATH, no dups
for pathentry in .; do
  case ":$PATH:" in
    *":$pathentry:"*) :;; # do nothing, already there
    *) PATH="$PATH:$pathentry";;
  esac
done

LD_LIBRARY_PATH=/usr/lib
export LD_LIBRARY_PATH
export TZ="America/Denver"
MANPATH=/usr/share/man
PROFILE=true
EDITOR=vi
VISUAL=vi
PAGER=less

#older Solaris sometimes does not know about UTF-8 locale
#Buildroot may not even have locale installed
LANG=C
if type locale >/dev/null 2>&1; then
  if locale -a | grep -i en_US.utf8 >/dev/null 2>&1; then
    LANG=en_US.UTF-8
  fi
fi
#include (){
#  if [ -r "$1" ]; then
#    . "$1" fi
#}


case "$(uname -s | cut -d_ -f1)" in
  Linux)
    if [[ -d /usr/X11R6/man ]]; then
      MANPATH=${MANPATH}:/usr/X11R6/man
    fi
    export PATH MANPATH

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

    #sane settings for systemd:
    alias systemctl="systemctl -l --no-pager"

    alias dit="docker run -it --rm -v /var/run/docker.sock:/var/run/docker.sock nate/dockviz images -t"
    alias drm='docker rm -v $(docker ps --filter status=exited -q 2>/dev/null) 2>/dev/null'
    alias drmi='docker rmi $(docker images --filter dangling=true -q 2>/dev/null) 2>/dev/null'
    if type bat >/dev/null 2>&1; then
    # bat is a much better cat https://github.com/sharkdp/bat
      alias cat=bat
    elif type batcat >/dev/null 2>&1; then
      #/usr/bin/bat exe in ubuntu bat package conflicts with another package so it might be installed as batcat
      alias cat=batcat
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
    alias psc='ps xawf -eo pid,user,cgroup:40,args' #show process tree
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
  if ls --color=tty > /dev/null 2>&1 ; then
    alias ls='ls -F --color=tty'
    grep --color=auto doesnotexist /dev/null >/dev/null 2>&1
    if [ "$?" -eq "1" ]; then  #grep understands --color=tty option
      alias grep='grep --color=auto'
      alias egrep='egrep --color=auto'
      alias fgrep='fgrep --color=auto'
    fi

    eval "$(dircolors -b "${RUNDIR}/.dir_colors"  2> /dev/null)"
  fi
}
setDirColors
unset -f setDirColors



#6/3/2011 - if ENV is uncommented, some AIX systems will display man pages with short column widths when this .bashrc is sourced from another user such as wicaadm
#ENV=$HOME/.profile

export FCEDIT PROFILE EDITOR VISUAL PAGER HOSTNAME PATH MANPATH HISTFILE HISTSIZE ENV LANG
#are we an interactive shell?
if [ "$PS1" ]; then
  if [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
  set -o emacs

  #stupid finger patch
  alias mroe=more
  alias gerp=grep
  alias grpe=grep
  alias duf='du -sk * | sort -nr | perl -ne '\''($s,$f)=split(m{\t});for (qw(K M G)) {if($s<1024) {printf("%.1f",$s);print "$_\t$f"; last};$s=$s/1024}'\'''
  alias which='type -a'  # More helpful which

  alias ssh='ssh -A'  #single sign-on

  FCEDIT=vi

  installidusage(){
    echo "usage: installid [user@]hostname"
    echo "usage examples:"
    echo
    echo "install my public key into the gclaybur user on host ogre:"
    echo "  installid gclaybur@ogre"
    echo
    echo "install my public key into the \$USER user on host evans.example.com:"
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
        echo "# This is a generated list of known places where this user can login with public key" >> "${ASSIMILATED_HOSTS}"
      fi
      echo "$1" >> "${ASSIMILATED_HOSTS}";
    fi
  }

  dateeval(){
    echo "$(date +%Y-%m-%d_%T) --> $*"
    eval "$*"
  }

  pushdotfiles(){
    # this is a push equivalent of installing these dotfiles via pull: curl -L http://bit.ly/universaldotfiles | bash
    # usage for host bayard and user gclaybur:
    # pushdotfiles bayard:tmpgclaybur
    # pushdotfiles gclaybur@bayard:tmpgclayburdotfiles
    # pushdotfiles bayard
    # pushdotfiles someotheruser@bayard
    BACKUPDIR=.dotfiles.backedup.$(date "+%Y-%m-%d_%H-%M-%S")
    USER_SPEC=$1
    if echo "$1" | grep : > /dev/null ; then # assume $1 is of the form: someuser@jaxaf2661:tmpdontoverwritesomeuserdotfiles/
      USER_DIR="$1"
      USER_SPEC=$(echo "$1" | cut -d: -f1)
      USER_HIJACK=$(echo "$1" | cut -d: -f2)
      dateeval ssh "${USER_SPEC}" \""[ -d $USER_HIJACK ] || mkdir $USER_HIJACK"\"
      sshstatus=$?
      if [[ $sshstatus != 0 ]] ; then
        return $sshstatus
      fi

    else  #append : to specify home directory of user on remote host
      USER_DIR="$1":
      #backup any previous dotfiles
      dateeval ssh "$1" "mkdir $BACKUPDIR"
      sshstatus=$?

      if [[ $sshstatus != 0 ]] ; then
        return $sshstatus
      fi
      dateeval ssh "$1" "cp -p .bash\* .prof\* .dir_colors .inputrc ${BACKUPDIR}/ 2>/dev/null"
      dateeval ssh "$1" "rm .bash_login .bash_logout .bashrc .profile .dir_colors .inputrc 2>/dev/null"
    fi
    dateeval scp -rp .bash_login .bash_logout .bashrc .profile .dir_colors .inputrc "${USER_DIR}"
  }


  #allow bash to resize screen area when terminal window size changes
  shopt -s checkwinsize

  #allow C-s (forward search to work in shell)
  stty stop undef

  # number of commands to remember in the command history
  HISTSIZE=100000
  # The maximum number of commands to remember in the history file
  HISTFILESIZE=500000
  # append to the history file, don't overwrite it
  shopt -s histappend

  HISTCONTROL=ignoredups
#todo incorporate features from /etc/bash/bashrc from coreos

  # Disable completion when the input buffer is empty.  i.e. Hitting tab
  # and waiting a long time for bash to expand all of $PATH.
  shopt -s no_empty_cmd_completion

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


    case "$(uname -s | cut -d_ -f1)" in
      Linux)
        OSDETAIL=""
        HOSTCOLOR=${RED_UNDERLINE}  #default color if we can't determine which Linux
        LSB_RELEASE=$(lsb_release -i 2> /dev/null | cut -d: -f2 | sed s/'^\t'//)
        if [[ ! -z $LSB_RELEASE ]]; then
          case "$LSB_RELEASE" in
            Ubuntu | LinuxMint | Debian)
              HOSTCOLOR=${RED_ON_BROWN}
              ;;
            CentOS | RedHat)
              HOSTCOLOR=${B_RED}
              ;;
            *)
              HOSTCOLOR=${RED_ON_BLUE}
              ;;
          esac
        elif [[ -f /etc/debian_version ]]; then #debian buster/sid is using this, but not lsb_release
          HOSTCOLOR=${RED_ON_BROWN}
        elif [[ -e /etc/redhat-release ]]; then
          HOSTCOLOR=${B_RED}
        elif grep "^NAME.*CoreOS.*" /etc/os-release > /dev/null 2>&1 ; then
            HOSTCOLOR=${RED_ON_GRAY}
            OSDETAIL=$(grep "^VERSION=" /etc/os-release | cut -d= -f2)
          #/etc/coreos/update.conf  for channel: alpha,beta,stable
            OSDETAIL="${OSDETAIL} "$(grep "^GROUP=" /etc/coreos/update.conf | cut -d= -f2)" "
        elif grep "Buildroot" /etc/os-release >/dev/null 2>&1; then
           OSDETAIL="Buildroot "
           PRETTY=$(grep "PRETTY_NAME" /etc/os-release 2>&1)
           if [ "$?" == "0" ]; then
             eval $PRETTY
             OSDETAIL="${PRETTY_NAME} "
           fi
        fi

# gitpod /workspace/policyStart (master) $ head -1 /proc/1/sched
# supervisor (1, #threads: 11)

# ubuntu 18 or 22:
#$ head -1 /proc/1/sched
#systemd (1, #threads: 1)

# non systemd linux:
#$ head -1 /proc/1/sched
# init (1, #threads: 1)

# existing mongo container:
# $ docker exec 08728e19e701 head -1 /proc/1/sched
# mongod (1, #threads: 35)
        DOCKER=""
        if [[ -f /proc/1/sched ]]; then
          # do nothing if we are reasonably certain we are not in docker, i.e. a regular init or systemd linux
          local schedpid1=$(head -1 /proc/1/sched | cut -d' ' -f1)
          if [[ "${schedpid1}" != "init" && "${schedpid1}" != "systemd" ]]; then
            DOCKER="${BLUE}[[${schedpid1}]]${OFF} "
          fi
        fi

# this docker/kube detection likely doesn't work with newer docker?
        if [[ -z "${DOCKER}" && -f /proc/self/cgroup ]]; then
          if grep "docker" /proc/self/cgroup > /dev/null 2>&1; then
            DOCKER="[[docker]] "
          elif grep "kubepod" /proc/self/cgroup > /dev/null 2>&1; then
            DOCKER="[[kube]] "
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
    local xterm_titlebar='\[\e]0;\u@\h:\w\a\]'

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

    local p_display="\u@"  #lets only show DISPLAY on the prompt if it is not simply the default :0
    if [[ -n "${DISPLAY}" && "${DISPLAY}" != ":0" ]]; then
      local p_display='${DISPLAY:+$DISPLAY }\u@'  #pad $DISPLAY with one space at the end, if DISPLAY is set
    fi
    local p_host="${HOSTCOLOR}\h"

    #dash shell is confused by DIRSTACK
    local p_pwd="${YELLOW} "'$(if [ -n ${BASH_VERSION} ]; then echo ${DIRSTACK[0]}; else echo $PWD; fi)'
    # show directory stack in green, as long as PS1 is being evaluated by bash
    local p_dirstack=" ${GREEN}"'$(if [ -n ${BASH_VERSION} ]; then echo ${DIRSTACK[@]:1}; else echo ""; fi)'

    # " (master)", when in git master branch
    local p_gitbranch=""
    if git --version > /dev/null 2>&1 ; then
      #only evaluate git branch info if git is installed on this box
      #without this check, prompt rendering will slow down on boxes like ubuntu that spit out verbose info if git is not installed
      if [[ -e /etc/bash_completion.d/git-prompt ]]; then
        . /etc/bash_completion.d/git-prompt
        p_gitbranch='$(declare -F __git_ps1 &>/dev/null && __git_ps1 "[%s]")'
      elif [[ -e /etc/bash_completion.d/git ]]; then
        . /etc/bash_completion.d/git
        p_gitbranch='$(declare -F __git_ps1 &>/dev/null && __git_ps1 "[%s]")'
      else
        #git completion not installed on this box. use this inline method instead to show git branch
        p_gitbranch="${BLUE_ON_WHITE}"'$(git branch 2> /dev/null | sed -e "/^[^*]/d" -e "s/* \(.*\)/(\1)/" )'
      fi
    fi

    local p_ending="${OFF}"'\n\$ '

    local DMI_SYS_VENDOR=""
    if [[ -f /sys/devices/virtual/dmi/id/sys_vendor ]]; then
       DMI_SYS_VENDOR=$(cat /sys/devices/virtual/dmi/id/sys_vendor)" "
    fi
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
    base_prompt=${base_prompt}${OSDETAIL}
    base_prompt=${base_prompt}${DOCKER}
    base_prompt=${base_prompt}${DMI_SYS_VENDOR}
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
    #
    # however, exporting PS1 causes issues if you run a bash shell then try to execute /bin/dash, for example.
    # /bin/dash goes into an infinite loop trying to evaluate our bash PS1
    export PS1
    alias sh="PS1='\$0 $USER@$HOSTNAME \$ ' sh"  # use very minimal prompt for sh subshells
    alias dash="PS1='\$0 $USER@$HOSTNAME \$ ' dash"  # use very minimal prompt for sh subshells
  }
  export PROMPT_COMMAND='history -a'
  setPrompt
  unset -f setPrompt
fi # if $PS1
#echo "exit .bashrc"

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
if [[ -s "${RUNDIR}/.sdkman/bin/sdkman-init.sh" ]]; then
  export SDKMAN_DIR="${RUNDIR}/.sdkman"
  source "${RUNDIR}/.sdkman/bin/sdkman-init.sh"
fi

function loadfzfextras {
  function de() {
    if docker --version > /dev/null 2>&1 ; then
      # Select a running docker container to exec a shell
      local cid
      cid=$(docker ps | sed 1d | fzf -q "$1" | awk '{print $1}')
      if [ -n "$cid" ]; then
        echo "docker exec -it --detach-keys='ctrl-z,ctrl-z' $cid /bin/bash"
        if ! docker exec -it --detach-keys='ctrl-z,ctrl-z' "$cid" /bin/bash; then
          echo "docker exec -it --detach-keys='ctrl-z,ctrl-z' $cid /bin/sh"
          docker exec -it --detach-keys='ctrl-z,ctrl-z' "$cid" /bin/sh
        fi
      fi
    else
      echo "docker not installed"
    fi
  }
  
  # use forgit for interactive git
  # https://github.com/wfxr/forgit
  [ -f ${RUNDIR}/dev/forgit/forgit.plugin.sh ] && source ${RUNDIR}/dev/forgit/forgit.plugin.sh
}

if [[ -f ${RUNDIR}/.fzf.bash ]]; then
  # if fzf is installed from git into .fzf then use it.
  # see https://github.com/junegunn/fzf
  source ${RUNDIR}/.fzf.bash
  loadfzfextras
elif [[ -f /usr/share/doc/fzf/examples/key-bindings.bash ]]; then
# if fzf is installed on this box using a package manager like apt we want it:
  source /usr/share/doc/fzf/examples/key-bindings.bash
  if [[ -f /usr/share/doc/fzf/examples/completion.bash ]]; then
    source /usr/share/doc/fzf/examples/completion.bash
  fi
  loadfzfextras
fi
unset -f loadfzfextras

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

#localhost overrides
if [[ -f ${RUNDIR}/.bashrc.${UNQUALIFIED_HOSTNAME} ]]; then
  source ${RUNDIR}/.bashrc.${UNQUALIFIED_HOSTNAME}
elif [[ -f ${RUNDIR}/.bashrc.localhost ]]; then
  source ${RUNDIR}/.bashrc.localhost
fi
