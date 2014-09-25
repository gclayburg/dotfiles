#!/bin/bash
SOURCE_DIR=/export/home/gclaybur/
BACKUP_HOME=/mnt/backups/ogre-export-home-gclaybur/
date=`date "+%Y-%m-%d_%H-%M-%S"`
RUNDIR=$( cd "$( dirname "$0" )" && pwd )

GETOPTS_ARGS="s:d:"
if ( ! getopts $GETOPTS_ARGS opt ); then
  echo "nothing to do!"
  usage
else
  while getopts $GETOPTS_ARGS name
  do
    case $name in
      s)  #echo "p arg is $OPTARG";
          SOURCE_DIR=$OPTARG;;
      d)  #echo "p arg is $OPTARG";
          BACKUP_HOME=$OPTARG;;
      *)  usage;;
    esac
  done
fi


#-------------------------------------------------------------------------
do_shell(){
# Execute command in shell, while logging complete command to stdout
    if [[ ! ${COMMANDS_DISABLED} ]]; then
      echo "$(date +%Y-%m-%d_%T) --> $*"
      eval "$*"
      STATUS=$?
#      echo "status= $STATUS"
    else
      echo "[not executed] $(date +%Y-%m-%d_%T) --> $*"
    fi
    return $STATUS
}



if [[ -L ${BACKUP_HOME}/current ]]; then
  echo "Performing incremental backup:"
  echo "    source: $SOURCE_DIR"
  echo "    destination: $BACKUP_HOME"
  do_shell rsync -HaxP --stats --exclude-from=${RUNDIR}/exclude-files.txt --link-dest=${BACKUP_HOME}/current ${SOURCE_DIR} ${BACKUP_HOME}/back-$date
  do_shell rm -f ${BACKUP_HOME}/current
  do_shell ln -s back-$date ${BACKUP_HOME}/current
else
  echo "No existing backups at: $BACKUP_HOME"
  echo "Creating initial backup:"
  echo "    source: $SOURCE_DIR"
  echo "    destination: $BACKUP_HOME"
  if [[ -w ${BACKUP_HOME} ]]; then
    do_shell rsync -HaxP --stats --exclude-from=${RUNDIR}/exclude-files.txt ${SOURCE_DIR} ${BACKUP_HOME}/back-$date
    do_shell ln -s back-$date ${BACKUP_HOME}/current
  else
    echo "Cannot write to: ${BACKUP_HOME}"
  fi
fi

