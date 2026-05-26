#!/bin/bash

MAJOR_VERSION=$1

# Check if MAJOR_VERSION is empty and nvidia-smi is installed
if [ -z "$MAJOR_VERSION" ] && command -v nvidia-smi &> /dev/null; then
# Get the currently installed NVIDIA driver version
NVIDIA_DRIVER_VERSION=$(nvidia-smi | grep "Driver Version" | awk '{print $3}')

# Extract major version number
MAJOR_VERSION=$(echo "$NVIDIA_DRIVER_VERSION" | sed 's/\([0-9]*\)\.[0-9]*.*/\1/')
fi

# If MAJOR_VERSION is still empty, default it to 580
if [ -z "$MAJOR_VERSION" ]; then
    MAJOR_VERSION=580
fi

# Check if the NVIDIA libraries are already installed
if dpkg -l | grep "nvidia.*$MAJOR_VERSION" &> /dev/null; then
    echo "NVIDIA libraries are already installed."
else
    # Install the matching NVIDIA driver
    echo "Installing NVIDIA libraries for version: $MAJOR_VERSION"
    add-apt-repository -y ppa:graphics-drivers/ppa
    apt update
    apt install -y --no-install-recommends libnvidia-compute-$MAJOR_VERSION libnvidia-decode-$MAJOR_VERSION libnvidia-encode-$MAJOR_VERSION \
    libnvidia-fbc1-$MAJOR_VERSION libnvidia-gl-$MAJOR_VERSION nvidia-compute-utils-$MAJOR_VERSION libnvidia-cfg1-$MAJOR_VERSION
    apt clean -y
	rm -rf /var/lib/apt/lists/*
fi

echo "NVIDIA libraries installation complete."