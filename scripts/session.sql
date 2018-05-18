SET LINESIZE 300
SET PAGESIZE 30
SET VERIFY OFF

COLUMN spid            HEADING 'SPID'            FORMAT 999999999999
COLUMN sid             HEADING 'SID'             FORMAT 9999
COLUMN serial#         HEADING 'Serial#'         FORMAT 99999
COLUMN oracle_user     HEADING 'Oracle User'     FORMAT A15
COLUMN osuser          HEADING 'OS User'         FORMAT A15
COLUMN machine         HEADING 'Machine'         FORMAT A25
COLUMN status          HEADING 'Status'          FORMAT A8
COLUMN program         HEADING 'Program'         FORMAT A30
COLUMN log_time        HEADING 'Login Time'      FORMAT A19
COLUMN event           HEADING 'Event'           FORMAT A30
COLUMN wait_class      HEADING 'Wait Class'      FORMAT A30
COLUMN seconds_in_wait HEADING 'Seconds In Wait' FORMAT 99999999

ACCEPT pcStatus  PROMPT "Status (ACTIVE / INACTIVE / ALL): "
ACCEPT pcOraUser PROMPT "Oracle User: "
ACCEPT pcOSUser  PROMPT "SO User: "
ACCEPT pcSID  PROMPT "SID: "

SELECT 'ALTER SYSTEM KILL SESSION ''' || s.sid || ',' || s.serial# || ''' IMMEDIATE;' AS CMD
FROM   v$session s
WHERE  s.username IS NOT NULL
AND    s.status = NVL(DECODE('&pcStatus', 'ALL', s.status, '&pcStatus'), s.status)
AND    UPPER(NVL(s.username, '')) = UPPER(COALESCE('&&pcOraUser', s.username, ''))
AND    UPPER(NVL(s.osuser, '')) = UPPER(COALESCE('&&pcOSUser', s.osuser, ''))
AND    s.sid = TO_NUMBER(NVL('&&pcSID', s.sid));

SELECT p.spid,
       s.sid,
       s.serial#,
       s.username oracle_user,
       s.osuser,
       s.machine,
       s.status,
       s.program,
       TO_CHAR(s.logon_time, 'YYYY-MM-DD HH24:MI:SS') log_time,
       w.event,
       w.wait_class,
       w.seconds_in_wait
FROM   v$session s,
       v$session_wait w,
       v$process p
WHERE  s.paddr = p.addr
AND    s.sid = w.sid (+)
AND    s.username IS NOT NULL
AND    s.status = NVL(DECODE('&&pcStatus', 'ALL', s.status, '&&pcStatus'), s.status)
AND    UPPER(NVL(s.username, '')) = UPPER(COALESCE('&&pcOraUser', s.username, ''))
AND    UPPER(NVL(s.osuser, '')) = UPPER(COALESCE('&&pcOSUser', s.osuser, ''))
AND    s.sid = TO_NUMBER(NVL('&&pcSID', s.sid))
ORDER  BY s.username,
          s.status,
          s.sid,
          s.serial#;
