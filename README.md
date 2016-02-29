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
* **alpha** - Consul server, Nomad server, Docker Engine
* **bravo** - Consul client, Nomad client, Connectable, Docker Engine
* **charlie** - Consul client, Nomad client, Connectable, Docker Engine
 
## Launching The Sandbox

`vagrant up` will launch the sandbox. The first time the sandbox is launched, it will take a bit 
of time as the various pieces are downloaded and installed.

## Installing Your First Job
In order to interact with Nomad, you need to ssh into the `alpha` box via `vagrant ssh alpha`. At this point you
will be in the `/home/vagrant` directory and need to switch to the `/vagrant` directory via `cd /vagrant`.  To 
verify that you don't have any currently running jobs use `bin/check-job.sh`.  You should see the message 
`No running jobs`.  Next we want to install a system service into the Nomad cluster.  Type `bin/submit-job.sh system-test.hcl`  
to install some caching services into all nodes in the cluster. To see how the deployment is going,
type `bin/submit-job.sh system-test.hcl` and it should show the `system-test` job running.  To shutdown the services,
type `bin/stop-job.sh system-test`.

## Installing A Service
Use `bin/submit-job.sh service-test.hcl` to install an Nginx instance on one of the agents in the cluster.
 
## Service Registration
Nomad automatically registers workloads in Consul.  You can examine the registrations via HTTP on `alpha`.

```
curl http://localhost:8500/v1/catalog/services | python -m json.tool

{
    "consul": [],
    "service-test-web-services-nginx": [
        "web",
        "experiment"
    ],
    "system-test-caching-services-redis": [
        "experiment",
        "caching"
    ]
}
```
 
To examine an individual service, try this:

```
curl http://localhost:8500/v1/catalog/service/system-test-caching-services-redis | python -m json.tool
[
    {
        "Address": "10.10.10.20",
        "CreateIndex": 1097,
        "ModifyIndex": 1101,
        "Node": "bravo",
        "ServiceAddress": "10.0.2.15",
        "ServiceEnableTagOverride": false,
        "ServiceID": "nomad-registered-service-b8419ed2-1d7c-da7e-fa48-003b84148b76",
        "ServiceName": "system-test-caching-services-redis",
        "ServicePort": 6379,
        "ServiceTags": [
            "experiment",
            "caching"
        ]
    },
    {
        "Address": "10.10.10.30",
        "CreateIndex": 1094,
        "ModifyIndex": 1103,
        "Node": "charlie",
        "ServiceAddress": "10.0.2.15",
        "ServiceEnableTagOverride": false,
        "ServiceID": "nomad-registered-service-c44fb7b8-be34-72d3-10cf-a3a783a7ef85",
        "ServiceName": "system-test-caching-services-redis",
        "ServicePort": 6379,
        "ServiceTags": [
            "experiment",
            "caching"
        ]
    }
]
```

## Service Discovery
Since Nomad can move containers around as jobs are scheduled, you need to use a service discovery mechanism to 
locate services that your container depends on. Given the proper configuration, Nomad will register workloads 
with Consul.  It is up to your application to pull the service location out of Consul.  To make this process 
almost painless, we are using [Connectable](https://github.com/gliderlabs/connectable) in conjunction with 
[Resolvable](https://github.com/gliderlabs/resolvable).  The way it works is that you specify a specially 
formatted Docker label in your task definition that tells Connectable how to map the service definition in 
Consul to how you want it mapped inside your container.  As container come and go, Resolvable keeps track of 
the locations and becomes a local DNS provider. 


```
config {
    image = "nginx:latest"
    network_mode = "host"
    labels {
        // this container can access a Redis instance via localhost:6379
        connect.6379 = "system-test-caching-services-redis.service.consul"
    }
}
```

# Troubleshooting

# License and Credits
This project is licensed under the [Apache License Version 2.0, January 2004](http://www.apache.org/licenses/).

# List of Changes

