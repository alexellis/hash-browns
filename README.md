# hash-browns

This repository contains:

* A Quick-Start recipe for monitoring an application with Prometheus.
* A tiny web-server for creating SHA256 hashes with a /metrics endpoint

> Read more on the related [blog post](http://blog.alexellis.io/prometheus-monitoring/)

### Get started

Initialize Docker Swarm locally

```
# docker swarm init
```

Build the image (optional)

```
# docker build -t alexellis2/hash-browns:0.4.0 . -f Dockerfile
```

Deploy:

```
# docker stack deploy tutorial --compose-file=./docker-compose.yml
```

View the site:

http://127.0.0.1:8080/

Open Prometheus:

http://127.0.0.1:9090/

### Notes for Raspberry PI:

Build for ARM:

```
# docker build -t alexellis2/hash-browns:0.2-armhf . -f Dockerfile.armhf
```

Deploy the stack with a separate compose-file:

```
# docker stack deploy tutorial --compose-file=./docker-compose.armhf.yml
```
