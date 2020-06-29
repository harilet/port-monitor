#!/bin/bash

#port moniter

echo "1.tcp"
echo "2.udp"
echo "3.both"
echo -n ":"
read option

echo -n "Time intrivel in second:"
read time

if [ $option -eq 1 ]; then
    state=ta
    p=TCP
elif [ $option -eq 2 ]; then
    state=ua
    p=UDP
else
    state=tua
    p="TCP and UDP"
fi

echo "Motitoring $p"

while true; do
    ss -"$state" >current
    sort current >sorted_current
    sleep "$time"
    ss -"$state" >updated
    sort updated >sorted_updated
    diff sorted_updated sorted_current >result

    if [ -s result ]; then
        zenity --warning --text="Change in port status"
        echo
        ss -"$state"
        echo
        echo "Continue Monitering[y:n]?"
        echo -n ":"
        read choice
        if [ "$choice" != 'y']; then
            break
        fi
    else
        echo "."
    fi
done