#!/bin/sh

while [ 1 ]
do

echo -e "\n+-----------------------------------------------------+"
echo "Checking CPU Usage on Our Testing Servers"
echo "+-----------------------------------------------------+"

for a in {01..09} {10..22}
do
echo -e "\nChecking CPU Usage on ts0$a"
cpu_use=$(ssh "ts0$a"i top -b -n1 | awk '/^Cpu/ {print $2}' | cut -d. -f1)
echo "CPU Used:" $cpu_use%
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

echo -e "\n+---------------------------------------------------+"
echo "Checking CPU Usage on Our Live Servers"
echo "+---------------------------------------------------+"

for b in {20..41} {46..60} {67..70} {75..102}
do
echo -e "\nChecking CPU Usage on serv$b"
cpu_use_server=$(ssh "ts0$a"i top -b -n1 | awk '/^Cpu/ {print $2}' | cut -d. -f1)
echo "CPU Used:" $cpu_use_server%
if [ $cpu_use_server -gt 85 ]; then
SUBJECT="ATTENTION: CPU Load Is High on serv$b at $(date)"
MESSAGE="/tmp/Mail.out"
TO="alok.sinha@alok.com"
  echo -e "\nCPU Current Usage is: $cpu_use_server%\n" >> $MESSAGE
  echo "+------------------------------------------------------------------+" >> $MESSAGE

  echo "Top CPU Process running on ts0$a" >> $MESSAGE

  echo "+------------------------------------------------------------------+" >> $MESSAGE

  echo "$(ssh "serv$b"i top -bn1 | head -20)" >> $MESSAGE
  mail -s "$SUBJECT" "$TO" < $MESSAGE
  rm /tmp/Mail.out

else
        echo "There is no issue with CPU Load with our Live Server."
fi
        done

echo "============================="
echo "Will Start after 30Sec."
echo -e "=============================\n"
sleep 30
done
