#!/bin/sh
go(){
    echo "--> $*"
    eval $*
}

BACKUPDIR=.dotfiles.backedup.`date "+%Y-%m-%d_%H-%M-%S"`
echo "Backing up current dotfiles to $BACKUPDIR"
go mkdir $BACKUPDIR
if [ "$?" = "0" ]; then
  for file in .bash_login .bash_logout .bashrc .profile .inputrc .dir_colors; do
    if [ -r "$file" ]; then
      go cp -p $file ${BACKUPDIR}
      go rm $file
    fi
  done
  if type curl > /dev/null 2>&1; then
    go curl -O https://raw.githubusercontent.com/gclayburg/dotfiles/master/.bashrc \
      -O https://raw.githubusercontent.com/gclayburg/dotfiles/master/.bash_login \
      -O https://raw.githubusercontent.com/gclayburg/dotfiles/master/.bash_logout \
      -O https://raw.githubusercontent.com/gclayburg/dotfiles/master/.profile \
      -O https://raw.githubusercontent.com/gclayburg/dotfiles/master/.inputrc \
      -O https://raw.githubusercontent.com/gclayburg/dotfiles/master/.dir_colors
      COPY_STATUS=$?
  else
    wget https://raw.githubusercontent.com/gclayburg/dotfiles/master/.bashrc
    wget https://raw.githubusercontent.com/gclayburg/dotfiles/master/.bash_login
    wget https://raw.githubusercontent.com/gclayburg/dotfiles/master/.bash_logout
    wget https://raw.githubusercontent.com/gclayburg/dotfiles/master/.profile
    wget https://raw.githubusercontent.com/gclayburg/dotfiles/master/.inputrc
    wget https://raw.githubusercontent.com/gclayburg/dotfiles/master/.dir_colors
    COPY_STATUS=$?
  fi

  if [ "$COPY_STATUS" = "0" ]; then
    echo
    echo
    echo "dotfiles were successfully installed.  To use them, login to this box again or execute \". .bashrc\" "
  else
    echo
    echo "Error: cannot install files"
  fi
else
  echo
  echo "Error: Try re-running this script in a writeable directory"
  exit 99
fi
