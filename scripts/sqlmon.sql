SET LINESIZE 300
SET PAGESIZE 50
SET TRIMSPOOL ON
SET TERMOUT ON
SET VERIFY OFF
SET ECHO OFF
SET FEEDBACK OFF

COLUMN sid               HEADING "SID"
COLUMN status            HEADING "Status"            FORMAT A19
COLUMN username          HEADING "Username"
COLUMN sql_id            HEADING "SQL ID"
COLUMN sql_text          HEADING "SQL Text"          FORMAT A30
COLUMN sql_exec_start    HEADING "SQL Exec. Start"
COLUMN last_refresh_time HEADING "Last Refresh Time"
COLUMN duration          HEADING "Duration"          FORMAT A12
COLUMN elapsed_time      HEADING "Elapsed Time"      FORMAT A12
COLUMN cpu_time          HEADING "CPU Time"

ACCEPT pcUser   PROMPT "Username: "
ACCEPT pcStatus PROMPT "Status (QUEUED, EXECUTING, DONE, DONE (ERROR), DONE (FIRST N ROWS), DONE (ALL ROWS)):"

ALTER SESSION SET nls_date_format='YYYY-MM-DD HH24:MI:SS';

SELECT sid,
       status,
       username,
       sql_id,
       SUBSTR(sql_text, 1, 30) sql_text,
       sql_exec_start,
       last_refresh_time,
       SUBSTR(NUMTODSINTERVAL((last_refresh_time - sql_exec_start), 'DAY'), 9, 11) duration,
       SUBSTR(NUMTODSINTERVAL(elapsed_time/1000000, 'SECOND'), 9, 11) elapsed_time,
       SUBSTR(NUMTODSINTERVAL(elapsed_time/1000000, 'SECOND'), 9, 11) cpu_time
FROM   v$sql_monitor
WHERE  UPPER(username) = UPPER(NVL('&&pcUser', username))
AND    UPPER(status) LIKE UPPER(NVL('%&&pcStatus%', status))
ORDER  BY last_refresh_time DESC, sql_exec_start;
