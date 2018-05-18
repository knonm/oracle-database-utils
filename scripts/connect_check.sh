#!/bin/ksh
date +%Y-%m-%d_%H-%M-%S

uptime

lsnrctl status INSTANCE_NAME

sqlplus -s / as sysdba <<EOF
ALTER SESSION SET NLS_DATE_FORMAT='DD/MM/YYYY HH24:MI:SS';
SELECT instance_name, status, startup_time
FROM   v\$instance;
EOF

ps -ef | grep -i pmon_INSTANCE
