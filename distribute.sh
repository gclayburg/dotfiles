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
  go cp .bash* .prof* ~
  go tar -cvf dotfiles2009.tar .prof* .bash* .terminfo
  go scp -P 21 dotfiles2009.tar ogre:
  go scp -r -P 21 .bash* .prof* .terminfo ogre:
  go scp -r .bash* .prof* .terminfo jugglingfarmer:
  go scp -r .bash* .prof* .terminfo grunt:
  go scp -r .bash* .prof* .terminfo 192.168.1.120:
  go scp -r .bash* .prof* .terminfo 192.168.1.116:
  go scp -r .bash* .prof* .terminfo 192.168.1.117:
}

doOne(){
  if [  "$1" == "ogre" ]; then
    go scp -P 21 -r .bash* .prof* .terminfo "$1":
  else
    go scp -r .bash* .prof* .terminfo "$1":
  fi
}

usage(){
  echo "$0: must specify an option:"
  echo "  -a  distribute to all known hosts"
  echo " [ hostname ] distribute to hostname"
  exit 1
}

echo "num: $#"
if [ "$#" -eq "1"  ]; then
  case "$1" in
    -a)
      doAll
      ;;
    *)
      doOne "$1"
      ;;
  esac
else
  usage
fi

