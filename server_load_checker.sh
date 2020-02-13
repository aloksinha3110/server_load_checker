#!/bin/sh

for a in {01..09}
do
echo -e "\nChecking Memory and CPU Usage on ts0$a"
ram_use=$(ssh "ts0$a"i free -h | awk '/free/ {getline; x=$2; getline; print $3}' | awk -FG '{print $1}' | awk -F. '{print $1}')
echo "Used RAM:" $ram_use GB
total_Memory=$(ssh "ts0$a"i free -h  | grep ^Mem | tr -s ' ' | cut -d ' ' -f 2 | awk -FG '{print $1}')
echo "Total RAM:" $total_Memory GB
cpu_use=$(ssh "ts0$a"i top -b -n1 | awk '/^Cpu/ {print $2}' | cut -d. -f1)
echo "CPU Used:" $cpu_use%

avg_m=$((total_Memory * 90))
avg=$((avg_m /100))
#echo "$avg"

if [ $ram_use -gt $avg ]; then
SUBJECT="ATTENTION: Memory Utilization is High on ts0$a at $(date)"
MESSAGE="/tmp/Mail.out"
TO="alok.sinha@alok.com"
  echo -e "\nCurrent RAM Usage on ts0$a is: $ram_use GB\n" >> $MESSAGE
  echo "+------------------------------------------------------------------------------------+" >> $MESSAGE

  echo "Top 5 processes which consume most of the RAM on ts0$a" >> $MESSAGE

  echo "+------------------------------------------------------------------------------------+" >> $MESSAGE

  echo "$(ssh "ts0$a"i ps aux | awk '{print $2, $4, $11}' | sort -k2rn |head -5)" >> $MESSAGE

  mail -s "$SUBJECT" "$TO" < $MESSAGE
  rm /tmp/Mail.out

else
        echo "There is no issue with RAM."
fi

if [ $cpu_use -gt 85 ]; then
SUBJECT="ATTENTION: CPU Load Is High on ts0$a at $(date)"
MESSAGE="/tmp/Mail.out"
TO="alok.sinha@alok.com"
  echo -e "\nCPU Current Usage is: $cpu_use%\n" >> $MESSAGE
  echo "+------------------------------------------------------------------+" >> $MESSAGE

  echo "Top CPU Process running on ts0$a" >> $MESSAGE

  echo "+------------------------------------------------------------------+" >> $MESSAGE

  echo "$(ssh "ts0$a"i top -bn1 | head -20)" >> $MESSAGE
  mail -s "$SUBJECT" "$TO" < $MESSAGE
  rm /tmp/Mail.out

else
        echo "There is no issue with CPU Load."
fi

done
