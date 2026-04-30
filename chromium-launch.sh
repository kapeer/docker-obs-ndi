#!/bin/bash

export XDG_RUNTIME_DIR=/tmp/runtime
mkdir -p "$XDG_RUNTIME_DIR"
chmod 700 "$XDG_RUNTIME_DIR"

# Ensure DISPLAY is set or find one
if [ -z "$DISPLAY" ]; then
    export DISPLAY=:0
fi

# Launch Google Chrome with container-safe flags
exec google-chrome --no-sandbox --disable-gpu --disable-dev-shm-usage "$@"
