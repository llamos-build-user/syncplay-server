# syncplay-server

This docker image is for running instances of servers for Syncplay. For information on Syncplay, check out [their website](https://syncplay.pl).

Before using this image, please familiarize yourself with the standard [syncplay-server options](https://syncplay.pl/guide/server/). All options present there, are usable in this image.

To run a standard instance, use the following.
```
docker run -p 8999:8999 llamos/syncplay-server
```

To provide options for the server, append them as the run command.
```
docker run -p 8999:8999 llamos/syncplay-server --isolate-room --salt mysalt
```

To mount an motd-file, include a new volume with the file (or extend the base image with an ADD), and point to it with the command line switches.
```
docker run -p 8999:8999 -v /path/to/motd-file:/container/path/to/motd-file llamos/syncplay-server --motd-file /container/path/to/motd-file
```

Similarly, for TLS certs, include a new volume with the certificates, and provide the path via switches.
```
docker run -p 8999:8999 -v /path/to/certs:/crt llamos/syncplay-server --tls /crt
```

## docker-compose
---

Piecing everything together, here is an example `docker-compose.yml`.
```yaml
version: '3'

services:

  syncplay:
    image: llamos/syncplay-server:latest
    restart: unless-stopped

    command: --salt mysalt --password mypassword --tls /crt

    volumes:
      - /path/to/certs:/crt:ro

    ports:
      - 8999:8999
```
