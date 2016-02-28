// An example job that installs a service on one Linux agent 

job "service-test" {
    all_at_once = false
    datacenters = ["vagrant"]
    priority = 50
    region = "USA"
    type = "service"

    constraint {
        attribute = "${attr.kernel.name}"
        value = "linux"
    }

    update {
        max_parallel = 1
        stagger = "10s"
    }

    group "caching-services" {

        restart {
            attempts = 10
            interval = "5m"
            delay = "25s"
            mode = "delay"
        }

        task "redis" {

            driver = "docker"

            config {
                image = "nginx:latest"
                network_mode = "host"
                host_name = "nginx"
            }

            service {
                name = "${TASKGROUP}-nginx"
                tags = ["experiment", "web"]
                port = "nginx"
                check {
                    name = "alive"
                    type = "tcp"
                    interval = "30s"
                    timeout = "2s"
                }
            }

            resources {
                cpu = 500
                disk = 256
                memory = 512
                network {
                    mbits = 100
                    port "nginx" {
                        static = 80
                    }
                }
            }

            kill_timeout = "30s"
        }
    }
}