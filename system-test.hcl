job "system-test" {
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
                image = "redis:latest"
                network_mode = "host"
                host_name = "redis"
            }

            service {
                name = "${TASKGROUP}-redis"
                tags = ["experiment", "caching"]
                port = "redis"
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
                    port "redis" {
                        static = 6379
                    }
                }
            }

            kill_timeout = "30s"
        }
    }
}
