# fix for clipboard being passed through
vncconfig -nowin &

if ls /opt/startup_scripts/*.sh 1> /dev/null 2>&1; then
  for f in /opt/startup_scripts/*.sh; do
    bash "$f" -H || (echo "Error with $f: $?" >> /var/log/x11vnc_entrypoint.log)
  done
fi

# Configure Fluxbox style
FLUXBOX_STYLE=${FLUXBOX_STYLE:-bora_blue}
mkdir -p /root/.fluxbox
if [ ! -f /root/.fluxbox/init ]; then
  cp /usr/share/fluxbox/init /root/.fluxbox/init
fi
sed -i "s|^session.styleFile:.*|session.styleFile: /usr/share/fluxbox/styles/$FLUXBOX_STYLE|" /root/.fluxbox/init

# Start the window manager in the foreground so the VNC session remains alive
exec /usr/bin/fluxbox
