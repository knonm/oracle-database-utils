SET LINESIZE 300
SET PAGESIZE 0
SET LONG 2000000000
SET HEADING OFF
SET TRIMSPOOL ON
SET ECHO OFF
SET VERIFY OFF
SET FEEDBACK OFF

SPOOL asset_bkp.csv

SELECT INSTANCE_NAME    || ';' ||
       HOSTNAME         || ';' ||
       VIP_HOST         || ';' ||
       CONTINGENCY_HOST || ';' ||
       DR_HOST          || ';' ||
       CONTINGENCY_TYPE || ';' ||
       ENVIRONMENT_TYPE || ';' ||
       INSTANCE_STATUS  || ';' ||
       TO_CHAR(DISABLED_IN, 'DD/MM/YYYY') || ';' ||
       COMMENTS
FROM   schema1.tb_asset;

SPOOL OFF

EXIT
