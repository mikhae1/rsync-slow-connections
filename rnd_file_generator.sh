#!/usr/bin/env bash

set -eo pipefail

DST_DIR=/home/user/orchid-rsync/send
FMAX_SIZE=10000 # max file size in kb
MAX_FILES=5

main() {
  count=$(shuf -i 1-${MAX_FILES} -n 1)

  for i in $(seq 1 $count); do
    create
  done
}

create() {
  local name="tmp-$(date +%d.%m.%y)-${RANDOM}.mp3"
  local path="${DST_DIR}/${name}"
  local size=$(shuf -i 10-${FMAX_SIZE} -n 1)

  dd if=/dev/urandom of=${path} bs=1K count=$(( size ))

  log "file created: ${path}"
}

log() {
  echo -e "\n[$(date +'%Y-%m-%d %H:%M:%S%z')]: $@"
}

main "$@"
