#!/bin/bash

CONSUL="docker run \
       --detach \
       --restart=always \
       --net "host" \
       --name consul-server \
       kurron/docker-consul:latest agent -advertise=10.10.10.10 \
                                         -bind=10.10.10.10 \
                                         -client=10.10.10.10 \
                                         -data-dir=/var/lib/consul \
                                         -dc=vagrant \
                                         -server \
                                         -bootstrap-expect=1"

echo $CONSUL
eval $CONSUL

NOMAD="docker run \
       --detach \
       --restart=always \
       --net "host" \
       --name nomad-server \
       --volume /var/run/docker.sock:/var/run/docker.sock \
       kurron/docker-nomad:latest agent -bind=10.10.10.10 \
                                        -data-dir=/var/lib/nomad \
                                        -dc=vagrant \
                                        -region=USA \
                                        -server \
                                        -bootstrap-expect=1"

echo $NOMAD
eval $NOMAD

