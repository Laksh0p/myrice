#!/bin/bash

setsid kitty \
  --class bluetuith \
  --title bluetuith \
  --override background_opacity=0.85 \
  -e bluetuith >/dev/null 2>&1 &
