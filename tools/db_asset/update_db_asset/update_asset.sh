#!/bin/ksh
CURRPATH=$(pwd)
COMMAND=${CURRPATH}/update_asset_$(date +%d-%m%-y_%H%M%S).sql
LOG=${CURRPATH}/update_asset_$(date +%d-%m%-y_%H%M%S).log

while read ROW
do
  INST=$(echo $ROW | cut -f1 -d\;)
  HOSTN=$(echo $ROW | cut -f2 -d\;)
  VIPHOST=$(echo $ROW | cut -f3 -d\;)
  CONT_HOST=$(echo $ROW | cut -f4 -d\;)
  DR_HOST=$(echo $ROW | cut -f5 -d\;)
  CONT_TYPE=$(echo $ROW | cut -f6 -d\;)
  ENV_TYPE=$(echo $ROW | cut -f8 -d\;)
  INST_STATUS=$(echo $ROW | cut -f9 -d\;)
  DISABLED_IN=$(echo $ROW | cut -f10 -d\;)
  COMMENTS=$(echo $ROW | cut -f11 -d\;)

  sqlplus -s / as sysdba <<EOF > /dev/null
     SET LINESIZE 300
     SET PAGESIZE 0
     SET HEADING OFF
     SET FEEDBACK OFF
     SET TRIMSPOOL ON
     SET VERIFY OFF
     SET ECHO OFF

     COLUMN A FORMAT A300

     SPOOL ${COMMAND} APPEND

     SELECT
      DECODE((SELECT COUNT(*) FROM schema1.tb_asset WHERE UPPER(instance_name) = UPPER(TRIM('${INST}')) AND UPPER(hostname) = UPPER(TRIM('${HOSTN}'))),
      0,
      '
      INSERT INTO schema1.tb_asset
      (
      instance_name,
      hostname,
      vip_host,
      contingency_host,
      dr_host,
      contingency_type,
      environment_type,
      instance_status,
      disabled_in,
      comments,
      last_modified
      )
      VALUES
      (
      TRIM(''${INST}''),
      TRIM(''${HOSTN}''),
      TRIM(''${VIPHOST}''),
      TRIM(''${CONT_HOST}''),
      TRIM(''${DR_HOST}''),
      TRIM(''${CONT_TYPE}''),
      TRIM(''${ENV_TYPE}''),
      TRIM(''${INST_STATUS}''),
      TO_DATE(TRIM(''${DISABLED_IN}''), ''DD/MM/YYYY''),
      TRIM(''${COMMENTS}''),
      SYSDATE
      );',
      'UPDATE schema1.tb_asset
      SET    instance_name          = TRIM(''${INST}''),
             hostname               = TRIM(''${HOSTN}''),
             vip_host               = TRIM(''${VIPHOST}''),
             contingency_host       = TRIM(''${CONT_HOST}''),
             dr_host                = TRIM(''${DR_HOST}''),
             contingency_type       = TRIM(''${CONT_TYPE}''),
             environment_type       = TRIM(''${ENV_TYPE}''),
             instance_status        = TRIM(''${INST_STATUS}''),
             disabled_in            = TO_DATE(TRIM(''${DISABLED_IN}''), ''DD/MM/YYYY''),
             comments               = TRIM(''${COMMENTS}''),
             last_modified          = SYSDATE
      WHERE  UPPER(instance_name) = UPPER(''${INST}'')
      AND    UPPER(hostname)  = UPPER(''${HOSTN}'');'
      ) AS "A"
      FROM dual;

     PROMPT

     SPOOL OFF

EOF

done < ${CURRPATH}/asset.csv

sqlplus -s / as sysdba <<EOF >> ${LOG}
     SET LINESIZE 300
     SET PAGESIZE 0
     SET HEADING OFF
     SET FEEDBACK OFF
     SET TRIMSPOOL ON
     SET VERIFY OFF
     SET ECHO OFF
     @$COMMAND
     COMMIT;
EOF
