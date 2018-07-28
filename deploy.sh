#!/bin/bash

cd $PROJECT_DIR
git fetch origin && git reset --hard origin/master

docker_id=$(docker ps -aqf "name=portfolio_site")
docker exec $docker_id bundle check
can_restart=$?

docker build -t portfolio_site .

if [[ $can_restart -eq 0 ]]; then
  docker restart $docker_id
else
  docker stop $docker_id
  docker rm $docker_id
  docker run --name portfolio_site -e VIRTUAL_HOST=$VIRTUAL_HOST -e LETSENCRYPT_HOST=$LETSENCRYPT_HOST -e LETSENCRYPT_EMAIL=$LETSENCRYPT_EMAIL -v $PROJECT_DIR:/app -d portfolio_site
fi

docker system prune -f
