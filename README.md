# Terraria Docker Server
Dedicated server for [Terraria](https://store.steampowered.com/app/105600/Terraria/).

## About
Dedicated Docker image for video game Terraria.  No mods are included with image.  This image is self contained, with everything needed to standup a headless Terraria dedicated server.

## Build
If you are pulling down this repo and building the image yourself, use `docker build -t terraria-server .`.

## Network
The network port is set in the Docker compose file or in the Docker command from CMI.  The default port is 7777 tcp.  If standing up multiple Terraria servers, change the port (along with map used).

## Volumes
Server uses one volume. Volume will contain...

## Usage

### Docker Compose
The docker-compose.yaml is included. Use `docker-compose up -d` to bring up the server, and then `docker-compose down` to bring the server down.

### Docker CLI
```bash
docker run -it --rm \
    --name terraria-server \
    -p 7777:7777 \
    --volume=terraria_data:/opt/terraria/data \
    -d wrightcameron/terraria-server
```
While running Docker Compose or Docker CLI interactively (not `-d` mode), you can simply press `CTRL+C` once to gracefully stop the server.