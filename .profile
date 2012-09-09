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

PROFILE_HOME=${DOT_HOME:-`dirname "${HOME}/.profile"`}
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
MY_HOST=`uname -n`
case "`uname -s | cut -d_ -f1`" in
  Linux)
    include "${PROFILE_HOME}/.profile_linux"
    include "${PROFILE_HOME}/.profile_linux_${MY_HOST}"
    PATH=/opt/ibm/ldap/V6.2/bin/32:${PATH}
    ;;
  SunOS)
    include "${PROFILE_HOME}/.profile_solaris"
    include "${PROFILE_HOME}/.profile_solaris_${MY_HOST}"
    ;;
  CYGWIN) #Win XP, 2000, NT, Vista?
    include "${PROFILE_HOME}/.profile_cygwin"
    include "${PROFILE_HOME}/.profile_cygwin_${MY_HOST}"
    ;;
  HP-UX) 
    include "${PROFILE_HOME}/.profile_hp"
    include "${PROFILE_HOME}/.profile_hp_${MY_HOST}"
    ;;
  AIX)  #AIX
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
    include "${PROFILE_HOME}/.profile_aix"
    include "${PROFILE_HOME}/.profile_aix_${MY_HOST}"
    ;;
  *)
    ;;
esac

MANPATH=$MANPATH:/usr/local/man:/usr/local/man/man1:/usr/local/man/man3:/usr/local/man/man5:/usr/local/man/man8:/usr/share/man

PROFILE=true
EDITOR=vi
VISUAL=vi
LANG=C

# Setup PS1 (prompt) for sh and ksh.
# This prompt also works for a basic, boring bash prompt 
# bash settings are overridden in .bashrc

export MY_USER=`whoami`
#if ( "$?" -ne "0" ) then
#  USER=`/usr/ucb/whoami`
#fi
HOSTNAME=`uname -n`
case "$MY_USER" in
  root)
    CHAR="#"
    ;;
  *)
    CHAR="$"
    ;;
esac

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
    whence less > /dev/null 2>&1
    [ "$?" == "0" ] && PAGER=less || alias less=more
    bash_ksh_prompt
    ;;
  *bash*)
    type less > /dev/null 2>&1
    [ "$?" == "0" ] && PAGER=less || alias less=more
    bash_ksh_prompt
    ;;
  *sh*)
    #blindly assume other shells have less installed
    PAGER=less
    #man will fail on AIX/ksh if ENV is set
    ENV=$HOME/.profile

    PS1="[${MY_USER:-?}@${HOSTNAME}] ${CHAR:-?} "
    ;;
  *)
    #blindly assume other shells have less installed
    PAGER=less
    #man will fail on AIX/ksh if ENV is set
    ENV=$HOME/.profile
    PS1="unknown shell$ "
    ;;
esac #case "$0"
#echo "profile PS1: $PS1"

#Customized history settings
TTY=`tty | sed -e 's,.*/,,'`
HISTFILE=$HOME/tmp/.ksh.history".${TTY}"
HISTSIZE=1000
FCEDIT=vi

export FCEDIT PROFILE EDITOR VISUAL PAGER HOSTNAME PATH MANPATH PS1 HISTFILE HISTSIZE ENV LANG


if [ -t 0 ]; then #we have tty, do interactive settings
  TT=$(tty | cut -d\/ -f3-)
  IP=$(who | grep $TT | sed -e 's,.*(,,' | cut -d\) -f1)
  #echo "IP: $IP"
  export DISPLAY=${DISPLAY:-"${IP}:0.0"}
  #echo "DISPLAY: $DISPLAY"
fi

# OS agnostic settings not always safe for Bourne shell
if [ "$0" != "sh" -a "$0" != "-sh" ]; then
  set -o emacs

  #stupid finger patch
  alias mroe=more
  alias gerp=grep
  alias grpe=grep
fi

#echo "exit .profile "
