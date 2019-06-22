#! /bin/bash

NOTIFICATIONFILE=/tmp/.notificationSent

if [ ! -f $NOTIFICATIONFILE ]; then
    printf "0" > $NOTIFICATIONFILE
fi
read -r NOTIFICATIONSENT < /tmp/.notificationSent

read -r BAT0 < /sys/class/power_supply/BAT0/capacity
read -r BAT1 < /sys/class/power_supply/BAT1/capacity

(( LEVELSUM = $BAT0 + $BAT1 ))

if [ $LEVELSUM -le 10 ]; then
    sudo systemctl suspend
elif [ $LEVELSUM -le 20 ] && [ $NOTIFICATIONSENT -ne 20 ]; then
    notify-send -u critical "Low Battery" "$LEVELSUM% Remaining."
    sed -i 's/.*/20/' $NOTIFICATIONFILE
elif [ $LEVELSUM -le 200 ] && [ $NOTIFICATIONSENT -ne 30 ] && [ $NOTIFICATIONSENT -ne 20 ]; then
    notify-send "Low Battery" "$LEVELSUM% Remaining."
    sed -i 's/.*/30/' $NOTIFICATIONFILE
fi
