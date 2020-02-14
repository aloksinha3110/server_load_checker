#!/bin/sh

while [ 1 ]
do

echo -e "\n+-----------------------------------------------------+"
echo "Checking Memory Usage on Our Testing Servers"
echo "+-----------------------------------------------------+"

for a in {01..09} {10..22}
do
echo -e "\nChecking Memory and CPU Usage on ts0$a"
ram_use=$(ssh "ts0$a"i free -h | awk '/free/ {getline; x=$2; getline; print $3}' | awk -FG '{print $1}' | awk -F. '{print $1}')
echo "Used RAM:" $ram_use GB
total_Memory=$(ssh "ts0$a"i free -h  | grep ^Mem | tr -s ' ' | cut -d ' ' -f 2 | awk -FG '{print $1}')
echo "Total RAM:" $total_Memory GB

avg_m=$((total_Memory * 90))
avg=$((avg_m /100))
echo This is avg: $avg GB
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
        echo "There is no issue with RAM on Testing Server ts0$a."
fi
done

echo -e "\n+---------------------------------------------------+"
echo "Checking Memory Usage on Our Live Servers"
echo "+---------------------------------------------------+"

for b in {20..41} {46..60} {67..70} {75..102}
do
echo -e "\nChecking Memory Usage on serv$b"
ram_use2=$(ssh "serv$b"i free -h | awk '/free/ {getline; x=$2; getline; print $3}' | awk -FG '{print $1}' | awk -F. '{print $1}')
echo "Used RAM:" $ram_use2 GB
total_Memory2=$(ssh "serv$b"i free -h  | grep ^Mem | tr -s ' ' | cut -d ' ' -f 2 | awk -FG '{print $1}')
echo "Total RAM:" $total_Memory2 GB


if [ $total_Memory2 -lt 64 ]; then
avg_12=$((total_Memory2 * 90))
avg_b=$((avg_12 /100))
echo "Average is: " $avg_b GB

if [[ $ram_use2 -gt $avg_b ]]; then
SUBJECT="ATTENTION: Memory Utilization is High on serv$b at $(date)"
MESSAGE="/tmp/Mail.out"
TO="alok.sinha@alok.com"
echo -e "\nCurrent RAM Usage on serv$b is: $ram_use2 GB\n" >> $MESSAGE
echo "+------------------------------------------------------------------------------------+" >> $MESSAGE

echo "Top 5 processes which consume most of the RAM on serv$b" >> $MESSAGE

echo "+------------------------------------------------------------------------------------+" >> $MESSAGE

echo "$(ssh "serv$b"i ps aux | awk '{print $2, $4, $11}' | sort -k2rn |head -5)" >> $MESSAGE

mail -s "$SUBJECT" "$TO" < $MESSAGE
rm /tmp/Mail.out

else
 echo "There is no issue with RAM. I am in first block"
	fi
fi

if [ $total_Memory2 -gt 120 ] ; then
avg_126=$((total_Memory2 * 97))
avg_c=$((avg_126 /100))
echo "Avg." $avg_c GB

if [[ $ram_use2 -gt $avg_c ]]; then

SUBJECT="ATTENTION: Memory Utilization is High on serv$b at $(date)"
MESSAGE="/tmp/Mail.out"
TO="alok.sinha@octro.com"
echo -e "\nCurrent RAM Usage on serv$b is: $ram_use2 GB\n" >> $MESSAGE
echo "+------------------------------------------------------------------------------------+" >> $MESSAGE

echo "Top 5 processes which consume most of the RAM on serv$b" >> $MESSAGE

echo "+------------------------------------------------------------------------------------+" >> $MESSAGE

echo "$(ssh "serv$b"i ps aux | awk '{print $2, $4, $11}' | sort -k2rn |head -5)" >> $MESSAGE

mail -s "$SUBJECT" "$TO" < $MESSAGE
rm /tmp/Mail.out

else
 echo "There is no issue with Memory. I am in Second Block"
	fi
fi
done
echo "============================="
echo "Will Start after 30Sec."
echo -e "=============================\n"
sleep 30
done
