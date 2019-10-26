# hash-browns

This repository contains:

* A Quick-Start recipe for monitoring an application with Prometheus.
* A tiny web-server for creating SHA256 hashes with a /metrics endpoint

> Read more on the related [blog post](http://blog.alexellis.io/prometheus-monitoring/)

### Get started

* Initialize Docker Swarm locally

    ```sh
    docker swarm init
    ```

* Deploy:

    ```sh
    docker stack deploy tutorial --compose-file=./docker-compose.yml
    ```
* View logs:

    ```sh
    docker service logs tutorial_hashbrowns
    ```

* View scrape targets

    ```sh
    http://localhost:9090/targets
    ```

* View the site:

    http://127.0.0.1:8080/

* Invoke the service to generate some logs

    ```sh
    curl -d test http://localhost:8080/hash
    
    9f86d081884c7d659a2feaa0c55ad015a3bf4f1b2b0b822cd15d6c15b0f00a08
    ```

* Open Prometheus:

    http://127.0.0.1:9090/

    View metrics such as `hash_seconds_sum` `hash_seconds_count` and `hash_seconds_bucket`


* Build the image (optional)

    ```sh
    make docker push manifest
    ```

### Notes for Raspberry PI:

A multi-arch Docker image is available, so you can use the same instructions.
