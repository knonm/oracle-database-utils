-- Audit session information about a schema

SELECT das.os_username,
       das.username,
       das.userhost,
       das.timestamp
FROM   dba_audit_session das
WHERE  das.timestamp BETWEEN TO_DATE('10/03/2017 12:40:00', 'DD/MM/YYYY HH24:MI:SS') AND TO_DATE('10/03/2017 13:16:00', 'DD/MM/YYYY HH24:MI:SS')
AND    das.username = 'SYS';
