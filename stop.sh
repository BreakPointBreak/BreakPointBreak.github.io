#!/bin/sh

MY_DIR="${BASH_SOURCE%/*}"
if [[ ! -d "$DIR" ]]; then MY_DIR="$PWD"; fi

( set -x;
  cd $MY_DIR
  docker-compose down -v
)
