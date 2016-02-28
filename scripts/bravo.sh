#!/bin/bash

CMD="docker run \
       --detach \
       --restart=always \
       --net "host" \
       --name nomad-client \
       --volume /var/run/docker.sock:/var/run/docker.sock \
       kurron/docker-nomad:latest agent -bind=10.10.10.20 \
                                        -data-dir=/var/lib/nomad \
                                        -dc=vagrant \
                                        -region=USA \
                                        -client \
                                        -servers 10.10.10.10 \
                                        -node-class=general-purpose"

echo $CMD
eval $CMD $*
