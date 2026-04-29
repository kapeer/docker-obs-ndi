# fix for clipboard being passed through
vncconfig -nowin &

if ls /opt/startup_scripts/*.sh 1> /dev/null 2>&1; then
  for f in /opt/startup_scripts/*.sh; do
    bash "$f" -H || (echo "Error with $f: $?" >> /var/log/x11vnc_entrypoint.log)
  done
fi

# Start the window manager in the foreground so the VNC session remains alive
exec /usr/bin/fluxbox
