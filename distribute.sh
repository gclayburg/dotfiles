#!/bin/bash

trap sorry INT

# function sorry() prints a message
sorry()
{
    echo "Ok.  We stop now."
    exit 1
}

go(){
  echo "--> $*"
  eval $*
}

doAll(){
  go cp .bash* .prof* .dir_colors ~
  go tar -cvf dotfiles2009.tar .prof* .bash* .terminfo .dir_colors tmp
  go scp -P 21 dotfiles2009.tar ogre:
  go scp -r -P 21 .bash* .prof* .terminfo .dir_colors ogre:
  go scp -r .bash* .prof* .terminfo .dir_colors jugglingfarmer:
  go scp -r .bash* .prof* .terminfo .dir_colors grunt:
  go scp -r .bash* .prof* .terminfo .dir_colors packers:
  go scp -r .bash* .prof* .terminfo .dir_colors vikings:
}

doOne(){
  go tar -cvf dotfiles2009.tar .prof* .bash* .terminfo .dir_colors tmp .inputrc
  if [  "$1" == "ogre" ]; then
    go scp -P 21 -r .bash* .prof* .terminfo .dir_colors tmp .inputrc "$1":
  else
    echo "$1" | grep : > /dev/null
    if [ "$?" == "0" ]; then # assume $1 is of the form: rbeatty@jaxaf2661:gclaybur/
      USER_DIR="$1"
      USER_SPEC=$(echo "$1" | cut -d: -f1)
      USER_HIJACK=$(echo "$1" | cut -d: -f2)
      go ssh ${USER_SPEC} "mkdir $USER_HIJACK"
    else  #append : to specify home directory of user on remote host
      USER_DIR="$1":
    fi
    go scp -rp bin .bash* .prof* .terminfo .dir_colors tmp .inputrc "${USER_DIR}"
#    go ssh "$1" chmod 644 .profile
  fi
}

installID(){
  echo "installid: $1"
  if [ -r "$HOME/.ssh/id_rsa.pub" ]; then
    PUBLIC_KEY="$HOME/.ssh/id_rsa.pub";
  elif [ -r "$HOME/.ssh/id_dsa.pub" ]; then
    PUBLIC_KEY="$HOME/.ssh/id_dsa.pub";
  else
    echo "No ssh key found."
    exit 1
  fi
  cat "$PUBLIC_KEY" | ssh "$1" "mkdir .ssh; chmod 700 .ssh; cat >> .ssh/authorized_keys"
  #cat "$HOME/.ssh/id_dsa.pub" | ssh "$1" "mkdir .ssh; chmod 700 .ssh; cat >> .ssh/authorized_keys"
  status=$?
  if [ "$status" != "0" ]; then 
    exit "$?"
  fi
  echo "sshkeys status: $status"

}

usage(){
  echo "$0: must specify an option:"
  echo "  -a  distribute to all known hosts"
  echo " [ hostname ] distribute to hostname"
  echo " ex 1: copy dotfiles to sy00084 under the gclaybur directory in the rbeatty account" 
  echo "       $0 rbeatty@sy00084:gclaybur/"    
  echo " ex 2: copy dotfiles and install ssh public key for gclaybur account on sy02001"
  echo "       $0 -id gclaybur@sy02001 "
  echo " ex 3: copy dotfiles and install ssh public key for default account (id) on sy02001"
  echo "       $0 -id sy02001 "
  echo " ex 3: copy dotfiles to gclaybur account on sy02001"
  echo "       $0 sy02001"
  exit 1
}

echo "num: $#"
if [ "$1" = "-?" -o "$1" = "-h" ]; then
  usage
elif [ "$#" -eq "1"  ]; then
  case "$1" in
    -a)
      doAll
      ;;
    *)
      doOne "$1"
      ;;
  esac
elif [ "$#" -eq "2" ]; then
  case "$1" in
    -id)
      shift
      installID "$1"
      doOne "$1"
      ./changepass.ex "$1"
      ;;
    *)
      usage
      ;;
  esac 
else
  usage
fi

