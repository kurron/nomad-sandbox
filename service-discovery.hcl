// Install a service that uses Connectable for service discovery

job "service-discovery" {
    all_at_once = false
    datacenters = ["vagrant"]
    priority = 50
    region = "USA"
    type = "system"

    constraint {
        attribute = "${attr.kernel.name}"
        value = "linux"
    }

    update {
        max_parallel = 1
        stagger = "10s"
    }

    group "service-discovery" {

        restart {
            attempts = 10
            interval = "5m"
            delay = "25s"
            mode = "delay"
        }

        task "nginx" {

            driver = "docker"

            config {
                image = "nginx:latest"
                network_mode = "host"
                // use local Consul agent as our DNS server for service discovery
                dns_servers = ["127.0.0.1"]
                labels {
                    //TODO: only works if the Glider Labs stuff is running 
                    // this container can access a Redis instance via localhost:6379
                    connect.6379 = "system-test-caching-services-redis.service.consul"
                }
            }

            service {
                name = "nginx"
                tags = ["experiment", "service-discovery"]
                port = "http"
                check {
                    name = "alive"
                    type = "tcp"
                    interval = "30s"
                    timeout = "2s"
                }
            }

            resources {
                cpu = 150
                disk = 256
                memory = 512
                network {
                    mbits = 100
                    port "http" {
                        static = 80
                    }
                }
            }

            kill_timeout = "30s"
        }
    }
}
