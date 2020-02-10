# server_load_checker
## BASH SCRIPT TO MONITOR CPU and MEMORY USAGE ON LINUX
## In order to run this script in your terminal do the following things:
```1. chmod +x /path/to/your/server_load_checker.sh```
run it by 

2. ```./server_load_checker.sh```

3. Install the monitorHost script as crontab using the editor:
```$ crontab -e```

## Append the following cronjob entry:
## Monitor remote host every 30 minutes using monitorHost
```30 * * * * /home/alok/bin/server_load```

Save and close the file.
