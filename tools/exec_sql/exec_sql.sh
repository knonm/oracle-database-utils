#!/bin/ksh
# Execute SQL script on local/remote Oracle Database instances (via tnsnames or LDAP)

OUTFILE=exec_sql_`date +%d-%m-%y_%H%M`.out
ERRFILE=exec_sql_`date +%d-%m-%y_%H%M`.err

export ORACLE_SID=ORASID
export ORAENV_ASK=NO
. oraenv
export ORAENV_ASK=YES

echo "----------------------------------------------------" 1>>${OUTFILE} 2>>${OUTFILE}

for INSTANCE in $(cat instances.txt)
do

  echo ${INSTANCE} 1>>${OUTFILE} 2>>${OUTFILE}
  sqlplus -s system/$(cat password.txt)@${INSTANCE} @script.sql 1>>${OUTFILE} 2>>${OUTFILE}
  echo "----------------------------------------------------" 1>>${OUTFILE} 2>>${OUTFILE}

done

exit 0
