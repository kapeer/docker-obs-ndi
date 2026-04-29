#!/bin/bash
/etc/init.d/dbus start
avahi-daemon --daemonize --no-drop-root
ln -sfn /config/obs-studio/ /root/.config/obs-studio
