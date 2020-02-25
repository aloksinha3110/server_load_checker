#!/bin/sh

echo -e "\n+-----------------------------------------------------+"
echo "Checking CPU Usage on Our Testing Servers"
echo "+-----------------------------------------------------+"

for a in {01..09} {10..22}
do

trigger=12.00
load=$(ssh "ts0$a"i cat /proc/loadavg | awk '{print $1}')

## Get the load average for the last 1 minutes.
LOAD1MIN="$(ssh "ts0$a"i uptime | awk -F "load average:" '{ print $2 }' | cut -d, -f1 | sed 's/ //g')"
## Get the load average for the last 10 minutes.
LOAD5MIN="$(ssh "ts0$a"i uptime | awk -F "load average:" '{ print $2 }' | cut -d, -f2 | sed 's/ //g')"
## Get the load average for the last 15 minutes.
LOAD15MIN="$(ssh "ts0$a"i uptime | awk -F "load average:" '{ print $2 }' | cut -d, -f3 | sed 's/ //g')"

response=`echo | awk -v T=$trigger -v L=$load 'BEGIN{if ( L > T){ print "greater"}}'`
echo -e "\nCPU Usage on ts0$a is = $load"

if [[ $response = "greater" ]] ; then
echo " There is issue with ts0$a Server. Sending you an alert."
SUBJECT="ATTENTION: CPU Load Is High on ts0$a at $(date)"
MESSAGE="/tmp/Mail.out"
TO="alok.sinha@octro.com"
 #rishabh.aggarwal@octro.com"
  echo -e "\nCPU Current Usage is: $load\n" >> $MESSAGE
  echo -e "\nLoad Average Over the Last: 1mint: $LOAD1MIN, 5mint: $LOAD5MIN, 15mint: $LOAD15MIN\n" >> $MESSAGE
  echo "+------------------------------------------------------------------+" >> $MESSAGE

  echo "Top CPU Process running on ts0$a" >> $MESSAGE

  echo "+------------------------------------------------------------------+" >> $MESSAGE

  echo "$(ssh "ts0$a"i top -bn1 | head -20)" >> $MESSAGE
  mail -s "$SUBJECT" "$TO" < $MESSAGE
  rm /tmp/Mail.out

else
        echo -e "There is no issue with CPU Load."
fi

done
