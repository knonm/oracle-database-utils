SET LINESIZE 300

COLUMN member FORMAT A60

SELECT group#,
       status,
       type,
       member
FROM   v$logfile
ORDER  BY group#,
          member;
