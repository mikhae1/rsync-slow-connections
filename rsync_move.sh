#!/usr/bin/env bash

set -eo pipefail

TIMEOUT=${TIMEOUT:-600}
LOCK_FILE=${LOCK_FILE:-/tmp/rsync.lock}

SRC_DIR=/home/user/to_send
SRC_MASK='*.mp3'

DST_SRV=rsync@remote_srv.local
DST_DIR=/home/rsync/synced_files

run=false

main() {
  # during sync new files could be created
  while true; do
    check
    sync
    sleep 1
  done
}

check() {
  if [ ! $(find ${SRC_DIR} -maxdepth 0 -type d -empty 2>/dev/null) ]; then
    [[ "$run" == "true" ]] && log 'new files are created during rsync, restarting...'
    return 1
  fi

  [[ "$run" == "false" ]] && log 'no new files are found'
  
  exit 0
}

sync() {
  log 'starting rsync...'

  run=true

  flock -n ${LOCK_FILE} -c \
    "timeout ${TIMEOUT} rsync -chvt --include ${SRC_MASK} --remove-source-files ${SRC_DIR}/* ${DST_SRV}:${DST_DIR}"

  log 'success!'
}

log() {
  echo -e "\n[$(date +'%Y-%m-%d %H:%M:%S%z')]: $@"
}

main "$@"
