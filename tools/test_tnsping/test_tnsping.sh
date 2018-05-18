#!/bin/ksh

# Check tnsping for instances in file "instances.txt"

OUTFILE=stdout.out
ERRFILE=stderr.err

for INSTANCE in $(cat instances.txt)
do

  echo "Checking TNS for instance ${INSTANCE}"

  TNSPING_STR=$(tnsping ${INSTANCE} | grep -i "Attempting to contact" | awk '{print substr($0,23)}' | awk '{gsub(" ", "", $0); print}')
  # TNSPING_HOST=$(echo $TNSPING_STR | awk 'IGNORECASE=1;{print substr($0,index($0,"HOST")+5,index($0,")(PORT")-index($0,"HOST")-5)}')
  TNSPING_PORT=$(echo ${TNSPING_STR} | awk 'IGNORECASE=1;{print substr($0,index($0,"PORT")+5,4)}')
  TNSPING_OK=$(tnsping ${INSTANCE} | tail -1 | awk '{print substr($1,1)}')

  TNSPING_HOST=`sqlplus -s system/$(cat password.txt)@${INSTANCE} as sysdba <<EOF

    SET TRIMSPOOL OFF
    SET ECHO OFF
    SET TERMOUT OFF
    SET VERIFY OFF

    SELECT UPPER(HOST_NAME) FROM v$instance;

    EXIT

EOF `

  if [ ${TNSPING_OK} = 'OK' ]
  then
    echo "${TNSPING_HOST};${TNSPING_PORT};${INSTANCE};${TNSPING_STR}" 1>>${OUTFILE} 2>>${ERRFILE}
  else
    echo "TNSPING NOK for instance ${INSTANCE}" 1>>${OUTFILE} 2>>${ERRFILE}
  fi

  echo "Instance ${INSTANCE} finished\n"

done
