#!/bin/bash
MICMUTE=/sys/devices/platform/thinkpad_acpi/leds/tpacpi::micmute/brightness
INPUT_DEVICE="'Capture'"
YOUR_USERNAME="wschaub"
if amixer sget $INPUT_DEVICE,0 | grep '\[on\]' ; then
    amixer sset $INPUT_DEVICE,0 toggle
#    echo "0 blink" > /proc/acpi/ibm/led
    echo 1 > $MICMUTE
    su $YOUR_USERNAME -c 'DISPLAY=":0.0" notify-send -t 50 \
            -i microphone-sensitivity-muted-symbolic "Mic MUTED"'
else
    amixer sset $INPUT_DEVICE,0 toggle                       
    su $YOUR_USERNAME -c 'DISPLAY=":0.0" notify-send -t 50 \
            -i microphone-sensitivity-high-symbolic "Mic ON"'
#    echo "0 on" > /proc/acpi/ibm/led 
    echo 0 > $MICMUTE
fi
