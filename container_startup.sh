#!/bin/bash
OUR_IP=$(hostname -i)
rm -rf /tmp/.X*
# Set default VNC password if not provided
VNC_PASSWD=${VNC_PASSWD:-123456}
# start VNC server (Uses VNC_PASSWD environment variable)
mkdir -p /tmp/.vnc && echo "$VNC_PASSWD" | vncpasswd -f > /tmp/.vnc/passwd
vncserver :0 -localhost no -nolisten -rfbauth /tmp/.vnc/passwd -xstartup /opt/x11vnc_entrypoint.sh
# start noVNC web server
/opt/noVNC/utils/launch.sh --vnc localhost:5900 --listen 5901 &

echo -e "\n\n------------------ VNC environment started ------------------"
echo -e "\nVNCSERVER started on DISPLAY=:0 \n\t=> connect via VNC viewer with $OUR_IP:5900"
echo -e "\nnoVNC HTML client started:\n\t=> connect via http://$OUR_IP:5901/vnc.html?host=$OUR_IP&port=5901&password=$VNC_PASSWD\n"

if [ -z "$1" ]; then
  tail -f /dev/null
else
  # unknown option ==> call command
  echo -e "\n\n------------------ EXECUTE COMMAND ------------------"
  echo "Executing command: '$@'"
  exec "$@"
fi
