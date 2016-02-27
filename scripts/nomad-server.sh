#!/bin/bash

CMD="docker run \
       --detach \
       --restart=always \
       --net "host" \
       --name nomad-server \
       --volume /var/run/docker.sock:/var/run/docker.sock \
       kurron/docker-nomad:latest agent -bind=10.10.10.10 -data-dir=/var/lib/nomad -dc=vagrant -region=USA -server -bootstrap-expect=1"

echo $CMD
eval $CMD $*
