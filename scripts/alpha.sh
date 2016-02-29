#!/bin/bash

mkdir -p /etc/consul.d

# TODO: see how we might do this as a system Nomad job
CONSUL="docker run \
       --detach \
       --restart=always \
       --net "host" \
       --name consul-server \
       --volume /etc/consul.d:/etc/consul.d \
       kurron/docker-consul:latest agent -advertise=10.10.10.10 \
                                         -bind=10.10.10.10 \
                                         -config-dir=/etc/consul.d \
                                         -data-dir=/var/lib/consul \
                                         -dc=vagrant \
                                         -recursor=8.8.8.8 \
                                         -recursor=8.8.4.4 \
                                         -server \
                                         -ui \
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

