docker rmi $(docker image ls -aq) --force
docker container stop $(docker container ls -aq)
docker container rm $(docker container ls -aq) {--force}
docker container ls -s
docker run -it -v /home/suporte/volume-docker:/app ubuntu ###bind mounts
docker run -it --mount type=bind,source=/home/suporte/volume-docker,target=/app ubuntu bash

docker network create --driver bridge minha-bridge
docker container run -d -it --name pong --network minha-bridge ubuntu sleep 1d
docker container run -d -it --name ubuntu01 --network minha-bridge ubuntu bash


docker run -d --network minha-bridge --name meu-mongo mongo:4.4.6
docker run -d --network minha-bridge --name alurabooks -p 3000:3000 aluradocker/alura-books:1.0