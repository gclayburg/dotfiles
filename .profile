# Generic .profile for sh, ksh and bash shells
# OS specific additions/overrides should go to:
# $DOT_HOME/.profile_linux     Linux systems
# $DOT_HOME/.profile_solaris   Solaris systems
# $DOT_HOME/.profile_cygwin    Windows XP/NT/2k systems using cygwin
# $DOT_HOME/.profile_aix       AIX systems
# $DOT_HOME/.profile_hp        HP-UX systems

#DOT_HOME should point to directory containing this .profile
# $HOME will work as long as $HOME always points to the directory where 
# this .profile resides. This may not be the case if the user does "sudo ksh" 
# and then ". /path/.profile"?

# DOT_HOME is set in .bashrc and should be more reliable, if using this .profile from a bash shell
#echo ".profile:  dot_home: $DOT_HOME"

#Fall back to using $HOME if DOT_HOME is not set, i.e. when using ksh or sh
#  $HOME will not always work to locate the os specific .profile files, such as
#  when you "su - root" on Solaris and then ". /export/home/username/.profile under ksh or sh
#  In this case, $HOME is reset to / and this script will not find the OS specific files.
#  The solution is to always do "su root" or just "su" and then ". /export/home/username/.profile"
#  if you really want to use sh or ksh.

# gitpod has its own .bash_profile that does 2 interesting things:
# 1.  sources .profile
# 2.  changes directory to the checked out workspace.
# So we need to use their provided .bash_profile.
# Their standard .profile will also source .bashrc if it exists.
# So we just try to mimic what they do to fit into this ecosystem.
# We want to use one standard .profile and .bashrc everywhere
# On gitpod, we only install .profile and .bashrc - see install.sh

# if running bash
if [ -n "$BASH_VERSION" ]; then
    # include .bashrc if it exists
    if [ -f "$HOME/.bashrc" ]; then
	    . "$HOME/.bashrc"
      bashsetup="yes"
    fi
fi

if [ -z "$bashsetup" ]; then
# We are not running bash

PROFILE_HOME=${DOT_HOME:-$(dirname "${HOME}/.profile")}
export PROFILE_HOME
#echo ".profile: profile_home is $PROFILE_HOME"

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

include (){
  if [ -r "$1" ]; then
    . "$1"
  fi
}

#OS specific override settings
MY_HOST=$(uname -n)
case "$(uname -s | cut -d_ -f1)" in
  Linux)
    ;;
  SunOS)
    ;;
  CYGWIN) #Win XP, 2000, NT, Vista?
    ;;
  HP-UX) 
    ;;
  AIX)
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
    ;;
  *)
    ;;
esac

MANPATH=$MANPATH:/usr/local/man:/usr/local/man/man1:/usr/local/man/man3:/usr/local/man/man5:/usr/local/man/man8:/usr/share/man

PROFILE=true
EDITOR=vi
VISUAL=vi

#older Solaris sometimes does not know about UTF-8 locale
if locale -a 2>&1 | grep -i en_US.utf8 1>/dev/null 2>&1; then
  LANG=en_US.UTF-8
else
  LANG=C
fi

# Setup PS1 (prompt) for sh and ksh.
# This prompt also works for a basic, boring bash prompt 

export MY_USER=$USER
#$USER might not be the effective user when using "su" on some systems
#`whoami` and `id` are more accurate, if they are installed
if whoami > /dev/null 2>&1; then
  MY_USER=$(whoami)
elif id > /dev/null 2>&1; then
  MY_USER=$(id | cut -d\( -f2 | cut -d\) -f1)
fi
HOSTNAME=$(uname -n)
YELLOW='\033[0;33m'
RED='\033[0;31m'
B_RED='\033[1;31m'
B_DARK_GRAY='\033[1;30m'
BLACK_ON_RED='\033[30;1;41m'
CYAN_ON_RED='\033[36;1;41m'
GREEN_ON_BLUE='\033[32;1;44m'
RED_ON_GREEN='\033[31;1;42m'
RED_ON_BROWN='\033[31;1;43m'
RED_ON_BLUE='\033[31;1;44m'
RED_ON_GRAY='\033[31;1;47m'
B_YELLOW_ON_RED='\033[1;41;33m'

COLOR_OFF='\033[00m'
busyboxcheck="unknown"
DOCKER=""
case "$(uname -s | cut -d_ -f1)" in
  Linux)

    HOSTCOLOR=${B_DARK_GRAY}  #default color if lsb_release not installed
    LSB_RELEASE=$(lsb_release -i 2> /dev/null | cut -d: -f2 | sed s/'^\t'//)
    if [ -n "$LSB_RELEASE" ]; then
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
    else
      busyboxcheck=$(cat --help 2>&1 | head -1 | cut -d" " -f1)
      case "$busyboxcheck" in
        BusyBox) #i.e. Synology Diskstation, or any busybox
          OSID=""
          if [ -r /etc/os-release ]; then
            OSID=$(grep "^ID=" /etc/os-release | cut -d= -f2)
            BB_DETAIL="BB $OSID "
          fi
          HOSTCOLOR=${RED_ON_GRAY}
          ;;
      esac
    fi
    if [ -f /proc/1/sched ]; then
      schedpid1=$(head -1 /proc/1/sched | cut -d' ' -f1)
      if [ "$schedpid1" != "init" ] && [ "$schedpid1" != "systemd" ]; then
        DOCKER="[[${schedpid1}]] "
      fi
    fi

    ;;
  VMkernel) #VMware ESXi
    busyboxcheck=$(cat --help 2>&1 | head -1 | cut -d" " -f1)
    BB_DETAIL="BB ESXi "
    HOSTCOLOR=${B_YELLOW_ON_RED}
    ;;
esac

case "$MY_USER" in
  root)
    CHAR="#"
    USERCOLOR=$RED
    ;;
  *)
    CHAR="$"
    USERCOLOR=$YELLOW
    ;;
esac
# embed color changes as sequence of non-printing characters - so that long editing commands don't get confused
COLORHOSTNAME='\['${HOSTCOLOR}'\]'$HOSTNAME'\['${COLOR_OFF}'\]'
MY_COLOR_USER='\['${USERCOLOR}'\]'"($0) \u"'\['${COLOR_OFF}'\]'

bash_ksh_prompt(){
#    echo "TERM is $TERM"
    case $TERM in
      xterm*|dtterm*|terminator|rxvt*)
        PS1=']0;${MY_USER:-%}@${HOSTNAME}:${PWD}
\! [${MY_USER:-%}@${HOSTNAME}:${PWD}]
${CHAR:-%} '
        ;;
      sun-cmd*)
        PS1=']l ${MY_USER:-%}@${HOSTNAME}:${PWD}\\
[${MY_USER:-%}@${HOSTNAME}:${PWD}]
\! ${CHAR-%} '
        ;;
      *)
        PS1='
[ ${MY_USER:-%}@${HOSTNAME}:${PWD}]
\! ${CHAR:-%} '
        ;;
    esac
}

case "$0" in
  *ksh*)
    #only set PAGER to less if less is installed
    if whence less > /dev/null 2>&1; then
      PAGER=less
    else
      alias less=more
    fi
    bash_ksh_prompt
    ;;
  *bash*)
    if type less > /dev/null 2>&1; then
      PAGER=less
    else
      alias less=more
    fi
    bash_ksh_prompt
    ;;
  *sh*)

    p_git_branch=''
    if git --version > /dev/null 2>&1 ; then
      #only evaluate git branch info if git is installed on this box
      #without this check, prompt rendering will slow down on boxes like ubuntu that spit out verbose info if git is not installed
      p_git_branch='$(git branch 2> /dev/null | sed -e "/^[^*]/d" -e "s/* \(.*\)/(\1)/" ) '
    fi

    if [ "$busyboxcheck" = "BusyBox" ]; then #busybox can do color prompts and some special prompt chars like \u \h \w but not late PS1 evaluation - things like '${PWD}'
      if type less > /dev/null 2>&1; then
        PAGER=less
      else
        alias less=more
      fi

      xterm_titlebar=''
      if [ "$TERM" == "xterm" ]; then
        xterm_titlebar='\[\e]0;\u@\h:\w\a\]'
      fi
#      PS1="\n${xterm_titlebar}($0) \u@${COLORHOSTNAME} $busyboxcheck \w\n\\$ "
# ash on busybox gets a little confused when newline is in prompt, so we squeeze it all on one line
# ash on busybox needs 2 escapes before $ for it to be displayed as # for root and $ for non-root
      PS1="${xterm_titlebar}${MY_COLOR_USER}@${COLORHOSTNAME} ${BB_DETAIL}${DOCKER}${p_git_branch}\w \\$ "

    else

      #blindly assume other shells have less installed
      PAGER=less
      #man will fail on AIX/ksh if ENV is set
      ENV=$HOME/.profile

      #if we are really running in a dash shell, don't try to colorize the prompt
      if [ -n "$BASH_VERSION" ]; then
        PS1="($0) [${MY_USER:-?}@${COLORHOSTNAME}] ${DOCKER}"
        PS1=$PS1"${p_git_branch}"
        PS1=$PS1'$(pwd) '"${CHAR:-?} "
      else
        PS1="($0) [${MY_USER:-?}@${HOSTNAME}] ${DOCKER}"
        PS1=$PS1"${p_git_branch}"
        PS1=$PS1'$(pwd) '"${CHAR:-?} "
      fi
    fi
    ;;
  *)
    #i.e.  $0 will be "-su" if you su from root to a user such as jenkins: su - jenkins
    #blindly assume other shells have less installed
    PAGER=less
    #man will fail on AIX/ksh if ENV is set
    ENV=$HOME/.profile
    PS1="unknown shell$ "
    ;;
esac #case "$0"
#echo "profile PS1: $PS1"

export PROFILE EDITOR VISUAL PAGER HOSTNAME PATH MANPATH ENV LANG

# OS agnostic settings not always safe for Bourne /ash shell
if [ "$0" != "sh" ] && [ "$0" != "-sh" ] && [ "$0" != "-ash" ] && [ "$0" != "ash" ] && [ "$0" != "/bin/sh" ] && [ "$0" != "/bin/ash" ]; then
  set -o emacs

  #stupid finger patch
  alias mroe=more
  alias gerp=grep
  alias grpe=grep
fi
fi
#echo "exit .profile "
