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

* View the site:

    http://127.0.0.1:8080/

* Open Prometheus:

    http://127.0.0.1:9090/


* Build the image (optional)

    ```sh
    make docker push manifest
    ```

### Notes for Raspberry PI:

A multi-arch Docker image is available, so you can use the same instructions.
