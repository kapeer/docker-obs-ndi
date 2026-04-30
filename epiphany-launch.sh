#!/bin/bash
set -e

export WEBKIT_DISABLE_SANDBOX=1
export XDG_RUNTIME_DIR=/tmp/runtime
mkdir -p "$XDG_RUNTIME_DIR"
chmod 700 "$XDG_RUNTIME_DIR"

exec dbus-launch --exit-with-session bash -lc 'exec epiphany-browser "$@" || exec falkon "$@"' dummy "$@"
