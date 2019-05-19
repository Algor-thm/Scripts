#! /bin/bash

read -r BAT0 < /sys/class/power_supply/BAT0/capacity
read -r BAT1 < /sys/class/power_supply/BAT1/capacity
read -r BAT0Status < /sys/class/power_supply/BAT0/status
read -r BAT1Status < /sys/class/power_supply/BAT1/status

notify-send "Battery Information:" "\nBattery 1: $BAT0Status $BAT0%\nBattery 2: $BAT1Status $BAT1%"
