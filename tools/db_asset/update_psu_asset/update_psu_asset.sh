#!/bin/ksh
SEN=pass
COMANDO=update_psu_asset_$(date +%d-%m%-y_%H%M%S).sql
LOG=update_psu_asset_$(date +%d-%m%-y_%H%M%S).log

mv asset.txt asset.txt.bkp > /dev/null

sqlplus -s / as sysdba << EOF > /dev/null
  SET LINESIZE 300
  SET PAGESIZE 0
  SET HEADING OFF
  SET FEEDBACK OFF
  SET TRIMSPOOL ON
  SET VERIFY OFF
  SET ECHO OFF

  SPOOL asset.txt
  SELECT DISTINCT instancia
  FROM   schema1.tb_asset;
  SPOOL OFF

  EXIT
EOF

for INST in $(cat asset.txt)
do
  MSGERRO=`sqlplus -s system/${SEN}@${INST} << EOF | egrep -i "ORA-" | egrep -i -v "ORA-28002" | egrep -i "ORA-"
    SPOOL $COMANDO APPEND
      @update_psu_asset.sql
    SPOOL OFF
    EXIT
EOF `

  if [ $? = 0 ]
  then
    echo "${INST}:" >> $LOG
    echo $MSGERRO   >> $LOG
    echo ""         >> $LOG
  fi

done

sqlplus -s / as sysdba << EOF >> $LOG
  @$COMANDO
  COMMIT;
  EXIT
EOF

rm asset.txt > /dev/null

exit 0
