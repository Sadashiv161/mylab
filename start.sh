#!/bin/bash

set -e

export DISPLAY=:1

Xvfb :1 -screen 0 1280x800x24 &

sleep 2

su - labuser -c "DISPLAY=:1 startxfce4" &

sleep 5

x11vnc \
    -display :1 \
    -forever \
    -shared \
    -nopw \
    -rfbport 5900 \
    -bg

websockify \
    --web=/usr/share/novnc/ \
    8080 \
    localhost:5900
