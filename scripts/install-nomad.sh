#!/bin/bash

sudo ansible-pull --checkout master \
                  --directory /opt/ansible-pull-nomad \
                  --inventory-file=/tmp/inventory  \
                  --module-name=git \
                  --url=https://github.com/kurron/ansible-pull-nomad.git \
                  --verbose playbook.yml
