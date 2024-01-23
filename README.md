# tailscale-sidecar

Installs the [Tailscale](https://tailscale.com/) client and runs it as a sidecar container in docker compose environments.

## Usage

Let's say you want your tailscale network to be accessible from your prometheus container.

Add the sidecar section to your `docker-compose.yaml`:

```yaml
version: "3"

networks:
  monitoring-network:
    external: true
  nginx-network:
    external: true

services:
  sidecar:
    image: tailscale-sidecar:latest
    cap_add:
      - NET_ADMIN
    sysctls:
     - net.ipv4.conf.all.src_valid_mark=1
    network_mode: 'service:prometheus'
    environment:
      TS_AUTHKEY: <your pre-auth key here>
      TS_HOSTNAME: prometheus-sidecar
      TS_LOGIN_SERVER: http://headscale.nginx-network:8080
    devices:
      - /dev/net/tun

  prometheus:
    build: ./prometheus
    restart: unless-stopped
    networks:
      - monitoring-network
      - nginx-network
    volumes:
      - ./data/prometheus:/prometheus
```

Exec into the prometheus container and ping some internal host:

```bash
docker compose exec prometheus bash
ping 100.64.0.3
```
