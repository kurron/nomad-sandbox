# Overview
This project is a set of [Vagrant](https://www.vagrantup.com/) boxes that are configured to run 
a [Nomad](https://www.nomadproject.io/) cluster which can be used for experimentation.

# Prerequisites
* a working [VirtualBox](https://www.virtualbox.org/) installation
* the [VirtualBox Extension Pack](https://www.virtualbox.org/wiki/Downloads) properly installed
* a working [Vagrant](https://www.vagrantup.com/) installation

# Building
This project is a collection of Vagrant files so there isn't anything to build.

# Installation
Other than the prerequisites, there is nothing to install.  Necessary files will be pulled over 
the network.

# Tips and Tricks

## Machine Topology
TODO
 
## Launching The Sandbox

`vagrant up` will launch the sandbox. The first time the sandbox is launched, it will take a bit 
of time as the various pieces are downloaded and installed.

## Installing Your First Job
In order to interact with Nomad, you need to ssh into the `alpha` box via `vagrant ssh alpha`. At this point you
will be in the `/home/vagrant` directory and need to switch to the `/vagrant` directory via `cd /vagrant`.  To 
verify that you don't have any currently running jobs use `bin/check-job.sh`.  You should see the message 
`No running jobs`.  Next we want to install a system service into the Nomad cluster.  Type ` bin/submit-job.sh system-test.hcl`  
to install some caching services into all nodes in the cluster. To see how the deployment is going,
type `bin/submit-job.sh system-test.hcl` and should show the `system-test` job running.  To shutdown the services,
type `bin/stop-job.sh system-test`.

# Troubleshooting

## VirtualBox Extension Pack 

# License and Credits
This project is licensed under the [Apache License Version 2.0, January 2004](http://www.apache.org/licenses/).

# List of Changes

