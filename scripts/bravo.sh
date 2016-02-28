#!/bin/bash

CONSUL="docker run \
       --detach \
       --restart=always \
       --net "host" \
       --name consul-client \
       kurron/docker-consul:latest agent -advertise=10.10.10.20 \
                                         -bind=10.10.10.20 \
                                         -data-dir=/var/lib/consul \
                                         -dc=vagrant \
                                         -join=10.10.10.10"

echo $CONSUL
eval $CONSUL

NOMAD="docker run \
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

echo $NOMAD
eval $NOMAD

