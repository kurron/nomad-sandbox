#!/bin/bash

CMD="docker run \
       --restart=always \
       --net "host" \
       --volume /var/run/docker.sock:/var/run/docker.sock \
       kurron/docker-nomad:latest agent -bind=10.10.10.10 -dc=vagrant -region=USA -server -bootstrap-expect=1"

echo $CMD
eval $CMD $*
