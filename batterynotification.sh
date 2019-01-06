#! /bin/bash

acpiOut=$(acpi)
batteryLevel1=`echo "$acpiOut" | awk '/^Battery 0:/ {print $4+0}'`
batteryLevel2=`echo "$acpiOut" | awk '/^Battery 1:/ {print $4+0}'`
batteryState1=`echo "$acpiOut" | awk '/^Battery 0:/ {print $3}' | sed 's/,$//'`
batteryState2=`echo "$acpiOut" | awk '/^Battery 1:/ {print $3}' | sed 's/,$//'`
batteryRemaining=`echo "$acpiOut" | awk '{print $5}'`
batteryFile=/tmp/.battery

if [ ! -f $batteryFile ]; then
    echo "$batteryLevel1" > $batteryFile
    echo "$batteryLevel2" >> $batteryFile
    echo "$batteryState1" >> $batteryFile
    echo "$batteryState2" >> $batteryFile
    echo "0" >> $batteryFile
    exit
fi

lastBatteryLevel1=$(cat $batteryFile | awk 'FNR == 1 {print $1}')
lastBatteryLevel2=$(cat $batteryFile | awk 'FNR == 2 {print $1}')
lastBatteryState1=$(cat $batteryFile | awk 'FNR == 3 {print $1}')
lastBatteryState2=$(cat $batteryFile | awk 'FNR == 4 {print $1}')
notificationSent=$(cat $batteryFile | awk 'FNR == 5 {print $1}')
echo "$batteryLevel1" > $batteryFile
echo "$batteryLevel2" >> $batteryFile
echo "$batteryState1" >> $batteryFile
echo "$batteryState2" >> $batteryFile
echo "$notificationSent" >> $batteryFile

checkBatteryLevel() {

    levelSum=$(($batteryLevel1+$batteryLevel2))

    if [ $levelSum -le 10 ]; then
	sudo systemctl suspend
    elif [[ $levelSum -le 20 && $notificationSent -ne 20 ]]; then
	notify-send -u critical "Low Battery" "$levelSum% Remaining."
	sed -i '5s/.*/20/' $batteryFile
	return;
    elif [[ $levelSum -le 30 && $notificationSent -ne 30 && $notificationSent -ne 20 ]]; then
	notify-send "Low Battery" "$levelSum% Remaining."
	sed -i '5s/.*/30/' $batteryFile
	return;
    fi

}

checkBatteryStateChange() {

    if [[ "$batteryState1" != "Discharging" && "$lastBatteryState1" == "Discharging" ]]; then
	notify-send "Charging" "Battery is now plugged in."
    fi

    if [[ "$batteryState1" == "Discharging" && "$lastBatteryState1" != "Discharging" ]]; then
	notify-send "Power unplugged" "Your computer has been unplugged."
    fi

}

checkBatteryStateChange
checkBatteryLevel
