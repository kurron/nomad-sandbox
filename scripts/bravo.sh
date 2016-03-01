#!/bin/bash

sudo mkdir -p /etc/consul.d
sudo chmod 0777 /etc/consul.d

# TODO: see how we might do this as a system Nomad job
CONSUL="docker run \
       --detach \
       --restart=always \
       --net "host" \
       --name consul-client \
       --volume /etc/consul.d:/etc/consul.d \
       kurron/docker-consul:latest agent -advertise=10.10.10.20 \
                                         -bind=10.10.10.20 \
                                         -config-dir=/etc/consul.d \
                                         -data-dir=/var/lib/consul \
                                         -dc=vagrant \
                                         -recursor=8.8.8.8 \
                                         -recursor=8.8.4.4 \
                                         -retry-join =10.10.10.10"

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

# Nomad does currently support volumes so we have to set up the container here
RESOLVABLE="docker run \
       --detach \
       --restart=always \
       --net "host" \
       --name resolvable \
       --volume /var/run/docker.sock:/tmp/docker.sock \
       --volume /etc/resolv.conf:/tmp/resolv.conf \
       gliderlabs/resolvable:master"

#echo $RESOLVABLE
#eval $RESOLVABLE

# Nomad does currently support volumes so we have to set up the container here
CONNECTABLE="docker run \
       --detach \
       --restart=always \
       --net "host" \
       --name connectable \
       --volume /var/run/docker.sock:/var/run/docker.sock \
       gliderlabs/connectable:master"

#echo $CONNECTABLE
#eval $CONNECTABLE

