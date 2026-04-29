#!/bin/bash
/etc/init.d/dbus start
service avahi-daemon start
ln -sfn /config/obs-studio/ /root/.config/obs-studio
