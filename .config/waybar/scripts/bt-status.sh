#!/bin/bash

status=$(bluetoothctl show | grep "Powered" | awk '{print $2}')

device=$(bluetoothctl info | grep "Name" | cut -d ' ' -f2-)

if [ "$status" = "yes" ]; then
    if [ -n "$device" ]; then
        echo " $device"
    else
        echo " On"
    fi
else
    echo " Off"
fi
