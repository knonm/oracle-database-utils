-- Active Session History query

SET LINESIZE 300

COLUMN "SAMPLE_TIME"   FORMAT A23
COLUMN "EVENT"         FORMAT A40
COLUMN "WAIT_CLASS"    FORMAT A40
COLUMN "SESSION_STATE" FORMAT A20
COLUMN "WAIT_TIME" HEADING "LAST_TIME_WAITED"

ACCEPT pcDateIni PROMPT "Start date (DD/MM/YYYY HH24:MI:SS): "
ACCEPT pcDateEnd PROMPT "End date (DD/MM/YYYY HH24:MI:SS): "
ACCEPT pcOwner   PROMPT "Owner: "

SELECT ash.sample_id,
       TO_CHAR(ash.sample_time, 'DD/MM/YYYY HH24:MI:SS.FF') AS "SAMPLE_TIME",
       ash.session_id,
       ash.session_state,
       ash.event,
       ash.time_waited,
       ash.wait_class,
       ash.wait_time,
       ash.sql_id,
       ash.sql_child_number,
       u.username
FROM   v$active_session_history ash,
       dba_users u
WHERE  ash.user_id = u.user_id
AND    u.username = NVL('&pcOwner', u.username)
AND    ash.sample_time BETWEEN TO_TIMESTAMP('&pcDateIni' || '.00', 'DD/MM/YYYY HH24:MI:SS.FF') AND TO_TIMESTAMP('&pcDateEnd' || '.00', 'DD/MM/YYYY HH24:MI:SS.FF')
ORDER  BY ash.sample_time ASC;

SELECT ash.sample_id,
       TO_CHAR(ash.sample_time, 'DD/MM/YYYY HH24:MI:SS.FF') AS "SAMPLE_TIME",
       ash.session_id,
       ash.session_state,
       ash.event,
       ash.time_waited,
       ash.wait_class,
       ash.wait_time,
       ash.sql_id,
       ash.sql_child_number,
       u.username
FROM   dba_hist_active_sess_history ash,
       dba_users u
WHERE  ash.user_id = u.user_id
AND    u.username = NVL('&pcOwner', u.username)
AND    ash.sample_time BETWEEN TO_TIMESTAMP('&pcDateIni' || '.00', 'DD/MM/YYYY HH24:MI:SS.FF') AND TO_TIMESTAMP('&pcDateEnd' || '.00', 'DD/MM/YYYY HH24:MI:SS.FF')
ORDER  BY ash.sample_time ASC;
