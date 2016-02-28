#!/bin/bash

CMD="docker run \
       --rm \
       --interactive \
       --tty \
       --net "host" \
       --user=$(id -u $(whoami)):$(id -g $(whoami)) \
       --volume $(pwd):/pwd \
       --volume /var/run/docker.sock:/var/run/docker.sock \
       kurron/docker-nomad:latest run -verbose  -address=http://10.10.10.10:4646 system-test.hcl"

echo eval $CMD
eval $CMD 
