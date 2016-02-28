// Installs Consul clients on all Linux agents

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

        task "consul-agent" {

            driver = "docker"

            config {
                image = "kurron/docker-consul:latest"
                network_mode = "host"
                command = "-data-dir=/var/lib/consul -dc=vagrant -join=10.10.10.10"
            }

            service {
                name = "${TASKGROUP}-consul"
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
                    port "rpc" {
                        static = 8400
                    }
                    port "http" {
                        static = 8500
                    }
                    port "dns" {
                        static = 8600
                    }
                }
            }

            kill_timeout = "30s"
        }
    }
}
