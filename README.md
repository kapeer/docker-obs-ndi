# Docker OBS Studio with NDI Support

This Docker container provides OBS Studio with NDI (Network Device Interface) support, running in a VNC environment. It's based on Ubuntu 24.04 and includes all necessary plugins for professional streaming and broadcasting.

## Features

- **OBS Studio**: Latest version with full functionality
- **NDI Support**: DistroAV plugin for NDI input/output
- **Multi-RTMP**: Plugin for streaming to multiple platforms simultaneously
- **VNC Access**: Connect via VNC client or web browser
- **Fluxbox WM**: Lightweight window manager with customizable themes
- **Web Browser**: Epiphany browser for in-container web access and JavaScript support
- **OBS WebSocket**: Enabled by default on port 4455 for remote control

## Quick Start

```bash
docker run --shm-size=256m -it \
  -p 5900:5900 \
  -p 5901:5901 \
  -p 4455:4455 \
  -v obs-config:/config \
  -e VNC_PASSWD=yourpassword \
  kap33r/docker-obs-ndi:latest
```

docker-compose with GPU support
```bash
services:
    obs-ndi:
        runtime: nvidia
        environment:
            VNC_PASSWD: 123456
            NVIDIA_VISIBLE_DEVICES: all
            NVIDIA_DRIVER_CAPABILITIES: all
        networks:
            br0:
                ipv4_address: ${YOUR_IP_HERE}
        shm_size: 256m
        volumes:
            - obs_ndi:/config
        deploy:
            replicas: 1
            resources:
                reservations:
                    devices:
                    - driver: nvidia
                        count: 0
                        capabilities: [gpu]
```

## Ports

- `5900`: VNC server (connect with VNC client)
- `5901`: noVNC web client (connect via browser)
- `4455`: OBS WebSocket server (for remote control)

## Environment Variables

- `VNC_PASSWD`: VNC password (default: 123456)
- `FLUXBOX_STYLE`: Fluxbox theme (default: bora_blue)

## Volumes

- `/config`: Persistent storage for OBS configuration and profiles

## Usage

1. **VNC Client**: Connect to `localhost:5900` with your VNC viewer
2. **Web Browser**: Open `http://localhost:5901/vnc.html` in your browser
3. **OBS WebSocket**: Connect to `ws://localhost:4455` for remote control

### Desktop Applications

Right-click on the desktop to access the menu:
- **OBS Screencast**: Launch OBS Studio with VirtualGL (`vglrun obs`)
- **Xterm**: Terminal emulator
- **Web Browser**: Epiphany browser (launched with sandbox disabled for container use)

### OBS Configuration

- OBS settings are saved to `/config/obs-studio`
- NDI sources are available in OBS under "Sources"
- Multi-RTMP dock can be added via View → Docks → Multi-RTMP

## Building

```bash
git clone https://github.com/Daedilus/docker-obs-ndi.git
cd docker-obs-ndi
docker build -t kap33r/docker-obs-ndi:latest .
```

## Requirements

- Docker with support for `--shm-size`
- At least 2GB RAM recommended
- GPU acceleration recommended for better performance

## Troubleshooting

- If the web client crashes, increase `--shm-size` to 512m
- OBS configuration persists in the `/config` volume
- Check container logs with `docker logs <container_id>`

## Credits

forked from [Daedilus/docker-obs-ndi](https://github.com/Daedilus/docker-obs-ndi)
