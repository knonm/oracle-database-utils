SET LINESIZE 500
SET PAGESIZE 500

COLUMN SID      FORMAT 9999
COLUMN SPID     FORMAT A8
COLUMN STATUS   FORMAT A25
COLUMN USERNAME FORMAT A20
COLUMN OSUSER   FORMAT A10
COLUMN MACHINE  FORMAT A25
COLUMN PROGRAM  FORMAT A35
COLUMN SQL_ID   FORMAT A15
COLUMN EVENT    FORMAT A25

ALTER SESSION SET NLS_DATE_FORMAT = 'DD/MM/YYYY HH24:MI:SS';

SELECT s.sid,
       s.serial#,
       p.spid,
       s.status ||  ' for ' || FLOOR(s.last_call_et/3600)||':'|| FLOOR(MOD(s.last_call_et, 3600)/60)||':'|| MOD(MOD(s.last_call_et, 3600), 60) "STATUS",
       s.username,
       s.osuser,
       s.machine,
       s.program,
       s.logon_time,
       s.sql_id,
       SUBSTR(s.event, 1, 25) "Event"
FROM   v$session s,
       v$process p
WHERE  s.username IS NOT NULL
AND    s.paddr = p.addr
AND    s.status = 'ACTIVE'
ORDER  BY s.logon_time;
