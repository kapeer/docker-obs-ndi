## Environment Variables

- `VNC_PASSWD`: VNC password (default: 123456)
- `FLUXBOX_STYLE`: Fluxbox theme (default: bora_blue)
- **MAJOR_VERSION**: Specify the major version of nvidia drivers to bundle into the image (default: 580)

## Usage

1. **VNC Client**: Connect to `localhost:5900` with your VNC viewer
2. **Web Browser**: Open `http://localhost:5901/vnc.html` in your browser
3. **OBS WebSocket**: Connect to `ws://localhost:4455` for remote control

### Desktop Applications

Right-click on the desktop to access the menu:
- **OBS Screencast**: Launch OBS Studio with VirtualGL (`vglrun obs`)
- **Xterm**: Terminal emulator
- **Web Browser**: Google Chrome (launched with `--no-sandbox` for container use)

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

- If the web client crashes, increase `--shm-size`
- OBS configuration persists in the `/config` volume
- Check container logs with `docker logs <container_id>`

## Credits

forked from [Daedilus/docker-obs-ndi](https://github.com/Daedilus/docker-obs-ndi)