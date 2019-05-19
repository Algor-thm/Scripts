#! /bin/bash

printf -v TIME '%(%H:%M)T'
notify-send "Time:" "\n$TIME"
