#!/bin/sh

case "$OSTYPE" in
   cygwin*)
      OPEN_BROWSER="cmd /c start"
      ;;
   linux*)
      OPEN_BROWSER="xdg-open"
      ;;
   darwin*)
      OPEN_BROWSER="open"
      ;;
    msys* | win32*)
      OPEN_BROWSER="start"
      ;;
esac
MY_DIR="${BASH_SOURCE%/*}"
if [[ ! -d "$DIR" ]]; then MY_DIR="$PWD"; fi

( set -x;
  cd $MY_DIR
  docker-compose up -d
)

CONTAINER_NAME=jekyll-bpb
CONTAINER_HOST=localhost
CONTAINER_PORT=$(docker port $CONTAINER_NAME 4000/tcp | sed 's/.*\://')
CONTAINER_URL="http://$CONTAINER_HOST:$CONTAINER_PORT"

$MY_DIR/util/wait-for-it.sh $CONTAINER_HOST:$CONTAINER_PORT \
  --timeout=180 \
  --strict \
  -- echo "$CONTAINER_NAME is running on $CONTAINER_HOST:$CONTAINER_PORT"
result=$?
if [[ $result -eq 0 ]]; then
  ( set -x;
    $OPEN_BROWSER $CONTAINER_URL
    docker logs -f $CONTAINER_NAME
  )
else
  ( set -x;
    docker logs $CONTAINER_NAME
  )
  echo "$CONTAINER_NAME is not available on $CONTAINER_HOST:$CONTAINER_PORT" 1>&2
fi
