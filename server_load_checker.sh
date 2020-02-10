#!/bin/bash

while [ 1 ]
do

for a in {01..09}
do
echo -e "\nChecking ping test on ts0$a"
ram_usages=$(ssh "ts0$a"i free | awk '/Mem/{printf("RAM Usage: %.2f\n"), $3/$2*100}'| awk '{print $3}')
cpu_usages=$(ssh "ts0$a"i top -bn1 | grep load | awk '{printf "%.2f%%\t\t\n", $(NF-2)}')
echo "Ram Usages:" $ram_usages
echo "CPU Usages:" $cpu_usages

if [ $ram_usages > 75 ]; then
        echo -e "RAM is using too much on ts0$a at $(date)\n Sending you an email alert"
        subject="RAM is using too much on ts0$a at $(date)"
        body="Check your ts0$a at $(date) for RAM Usages Issue"
        from="alok.sinha@alok.com"
        to="alok.sinha@alok.com"
        echo -e "Subject:${subject}\n${body}" | sendmail -f "${from}" -t "${to}"

elif [ $cpu_usages > 75 ]; then
        echo -e "CPU is using too much on ts0$a at $(date)\n Sending you an email alert"
        subject="CPU is using too much on ts0$a at $(date)"
        body="Check your ts0$a at $(date) for CPU Usages Issue"
        from="alok.sinha@alok.com"
        to="alok.sinha@alok.com"
        echo -e "Subject:${subject}\n${body}" | sendmail -f "${from}" -t "${to}"
else
        echo "All Working fine."
fi
done
done
