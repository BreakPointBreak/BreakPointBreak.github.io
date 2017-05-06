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
    msys*_)
      OPEN_BROWSER="start"
      ;;
    win32*)
      OPEN_BROWSER="start"
      ;;
esac
MY_DIR="${BASH_SOURCE%/*}"
if [[ ! -d "$DIR" ]]; then MY_DIR="$PWD"; fi

docker-compose up -d
CONTAINER_PORT=$(docker port jekyll-bpb 4000/tcp | sed 's/.*\://')
CONTAINER_URL="http://localhost:$CONTAINER_PORT"

i=0
max_count=10
until $(curl --output /dev/null --silent --head --fail $CONTAINER_URL); do
  i=$((i+1))
  if [ "$i" -gt "$max_count" ]; then
    echo "Timeout expired waiting for $CONTAINER_URL"
    exit
  fi
  printf '.'
  sleep 3
done
echo ""
docker logs jekyll-bpb
( set -x;
  $OPEN_BROWSER $CONTAINER_URL
)
