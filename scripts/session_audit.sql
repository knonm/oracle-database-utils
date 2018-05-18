ALTER SESSION SET NLS_DATE_FORMAT='YYYY-MM-DD HH24:MI:SS';

SET LINESIZE 300

COLUMN os_username FORMAT A20
COLUMN userhost FORMAT A20
COLUMN db_username FORMAT A20

SELECT os_username,
       userhost,
       username AS db_username,
       action_name,
       returncode,
       COUNT(1) AS cnt_event,
       MIN(timestamp) AS first_time_30_days,
       MAX(timestamp) AS last_time
FROM   dba_audit_session
WHERE  MONTHS_BETWEEN(SYSDATE, timestamp) < 1
AND    returncode <> 0
GROUP  BY username,
          os_username,
          userhost,
          action_name,
          returncode
ORDER  BY cnt_event DESC;
