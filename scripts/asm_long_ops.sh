#!/bin/ksh

# Oracle ASM long running operations
while true
do sqlplus -s / as sysdba << EOF
SET LINESIZE 300
COLUMN OPERATION format a9
COLUMN PASS formatmat a9
COLUMN STATE format a4
COLUMN ERROR_CODE format a44
SELECT * FROM v\$asm_operation;
EXIT
EOF
sleep 3
done
