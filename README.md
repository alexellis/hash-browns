# hash-browns

This repository contains:

* A Quick-Start recipe for monitoring an application with Prometheus.
* A tiny web-server for creating SHA256 hashes with a /metrics endpoint

> Read more on the related [blog post](http://blog.alexellis.io/prometheus-monitoring/)

### Notes for Raspberry PI:

Initialize swarm-mode

```
# docker swarm init
```

Build the image:

```
# docker build -t alexellis2/hash-browns . -f Dockerfile.armhf
```

Deploy the stack with a separate compose-file:

```
# docker stack deploy tutorial --compose-file=./docker-compose.armhf.yml
```
