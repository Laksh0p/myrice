#!/bin/bash

setsid -f kitty \
  --class kitty-popup \
  --title wifi-popup \
  --override background_opacity=0.9 \
  -e nmtui
