# Generic .profile for sh, ksh and bash shells
# OS specific additions/overrides should go to:
# $DOT_HOME/.profile_linux     Linux systems
# $DOT_HOME/.profile_solaris   Solaris systems
# $DOT_HOME/.profile_cygwin    Windows XP/NT/2k systems using cygwin
# $DOT_HOME/.profile_aix       AIX systems
# $DOT_HOME/.profile_hp        HP-UX systems

#DOT_HOME should point to directory containing this .profile
# $HOME will work as long as $HOME always points to the directory where this .profile resides
# This may not be the case if the user does "sudo ksh" and then ". /path/.profile"
# DOT_HOME is set in .bashrc and should be more reliable, if using this .profile from a bash shell
#DOT_HOME=/home/gclaybur
#DOT_HOME=$HOME
#echo ".profile:  dot_home: $DOT_HOME"

#Fall back to using $HOME if DOT_HOME is not set, i.e. when using ksh or sh
PROFILE_HOME=${DOT_HOME:-`dirname "${HOME}/.profile"`}
export PROFILE_HOME
#echo ".profile: profile_home is $PROFILE_HOME"
#case $- in
#  *i*)
#    stty istrip
#    #other commands for interactive shell here
#esac
#echo "enter .profile "

# OS common settings
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
    include "${PROFILE_HOME}/.profile_aix"
    include "${PROFILE_HOME}/.profile_aix_${MY_HOST}"
    ;;
  *)
    ;;
esac

# Setup PS1 (prompt) for sh and ksh.
# bash settings are overridden in .bashrc

USER=`whoami` 
HOSTNAME=`uname -n`
case "$USER" in
  root)
    CHAR="#"
    ;;
  *)
    CHAR="$"
    ;;
esac

case "$0" in
  ksh)
    #echo "TERM is $TERM"
    case $TERM in
      xterm*|dtterm*)
        PS1=']0;${USER}@${HOSTNAME}:${PWD}
\! [${USER}@${HOSTNAME}:${PWD}]
${CHAR} '
        ;;
      sun-cmd*)
        PS1=']l ${USER}@${HOSTNAME}:${PWD}\\
[${USER}@${HOSTNAME}:${PWD}]
\! ${CHAR} '
        ;;
      *)
        PS1='
[ ${USER}@${HOSTNAME}:${PWD}]
\! ${CHAR} '
        ;;
    esac
    ;;
  sh)
    PS1="
[ ${USER}@${HOSTNAME}:${PWD}]
sh ${CHAR} "
    ;;
esac #case "$0"


#Customized history settings
HISTFILE=$HOME/tmp/.ksh.history".${TTY}"
HISTSIZE=1000
FCEDIT=vi
ENV=$HOME/.profile
export FCEDIT PROFILE EDITOR VISUAL PAGER HOSTNAME PATH MANPATH PS1 HISTFILE HISTSIZE ENV

# not safe for Bourne shell
if [ "$0" != "sh" -a "$0" != "-sh" ]; then
  set -o emacs

  #stupid finger patch
  alias mroe=more
  alias gerp=grep
  alias grpe=grep
fi

#echo "exit .profile "
