# docker-dnsmasq

Lightweight `dnsmasq` container with a [simple web UI](https://github.com/jpillora/webproc) for editing and reloading configuration.

Originally based on a fork of `jpillora/dnsmasq`.

![Build workflow](https://github.com/leto1210/docker-dnsmasq/actions/workflows/docker-image.yml/badge.svg)
![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)
![Docker Pulls](https://img.shields.io/docker/pulls/leto1210/docker-dnsmasq)
[![Trivy security check](https://github.com/leto1210/docker-dnsmasq/actions/workflows/trivyV2.yml/badge.svg)](https://github.com/leto1210/docker-dnsmasq/actions/workflows/trivyV2.yml)

## Usage

### 1) Create your dnsmasq config

Create `/opt/dnsmasq.conf` on the Docker host:

```ini
# dnsmasq config

# Log DNS queries
log-queries

# Do not use host resolvers
no-resolv

# Upstream resolvers
server=8.8.4.4
server=8.8.8.8

# Route all .company requests to a specific resolver
server=/company/10.0.0.1

# Static mapping
address=/myhost.company/10.0.0.2

# Uncomment to enable DNSSEC
# conf-file=/usr/share/dnsmasq/trust-anchors.conf
# dnssec
```

### 2) Run the container

```bash
docker run \
  --name dnsmasq \
  -d \
  -p 53:53/udp \
  -p 5380:8080 \
  -v /opt/dnsmasq.conf:/etc/dnsmasq.conf \
  --log-opt "max-size=100m" \
  -e HTTP_USER=foo \
  -e HTTP_PASS=bar \
  --restart always \
  leto1210/docker-dnsmasq
```

### 3) Open the web UI

Go to `http://<docker-host>:5380` and authenticate with `foo/bar`.

<img width="833" alt="webproc UI" src="https://user-images.githubusercontent.com/633843/31580966-baacba62-b1a9-11e7-8439-ca1ddfe828dd.png">

### 4) Test DNS resolution

```bash
host myhost.company <docker-host>
```

Expected output includes:

```text
myhost.company has address 10.0.0.2
```

### 5) Reload `dnsmasq` without restarting the container

```bash
docker exec dnsmasq pkill -HUP dnsmasq
```

## Environment variables

- `HTTP_USER`: Web UI username
- `HTTP_PASS`: Web UI password

## Exposed ports

- `53/udp`: DNS service
- `8080/tcp`: web UI inside the container (often mapped to `5380` on host)

## License

MIT — see [LICENSE](LICENSE).
