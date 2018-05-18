SET LINESIZE 300
SET PAGESIZE 300
SET ECHO OFF
SET FEEDBACK OFF
SET TRIMSPOOL ON

COLUMN sid        FORMAT 9999
COLUMN sec        FORMAT 9999999999
COLUMN event      FORMAT A50
COLUMN p1         FORMAT 999999999999999
COLUMN wait_class FORMAT A25
COLUMN laddr      FORMAT A30
COLUMN object     FORMAT A50

SELECT w.sid,
       s.sql_id,
       w.event,
       w.wait_class,
       w.seconds_in_wait "sec",
       w.p1,
       w.p2,
       -- lpad(replace(to_char(W.P1,'XXXXXXXXX'),' ','0'),16,0) laddr
       NVL2(o.object_name, o.owner || '.' || o.object_name || '(' || o.object_type || ')', NULL) "object"
FROM   v$session_wait w,
       v$session s,
       v$process p,
       dba_objects o
WHERE  w.sid = s.sid AND
       s.paddr = p.addr AND
       w.event NOT IN ('pmon timer', 'smon timer', 'rdbms ipc message', 'wakeup time manager', 'jobq slave wait', 'PL/SQL lock timer') AND
       w.wait_class <> 'Idle' AND
       s.row_wait_obj# = o.object_id(+)
ORDER  BY w.seconds_in_wait,
          w.sid;
