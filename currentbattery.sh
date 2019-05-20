#! /bin/bash

read -r BAT0 < /sys/class/power_supply/BAT0/capacity
read -r BAT1 < /sys/class/power_supply/BAT1/capacity
read -r BAT0STATUS < /sys/class/power_supply/BAT0/status
read -r BAT1STATUS < /sys/class/power_supply/BAT1/status

notify-send "Battery Information:" "\nBattery 1: $BAT0STATUS $BAT0%\nBattery 2: $BAT1STATUS $BAT1%"
