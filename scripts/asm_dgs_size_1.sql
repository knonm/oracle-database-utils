-- ASM DG size
-- Execute as "sysasm" profile -> sqlplus / as sysasm

SET LINESIZE 300

COLUMN SERVER       HEADING  "Server"     FORMAT A45
COLUMN DISKGROUP    HEADING  "Diskgroup"  FORMAT A15
COLUMN TOTAL_GB     HEADING  "Total (GB)" FORMAT 999999999.99
COLUMN USED_GB      HEADING  "Used (GB)"  FORMAT 999999999.99
COLUMN FREE_GB      HEADING  "Free (GB)"  FORMAT 999999999.99
COLUMN USED_PCT     HEADING  "Used (%)"   FORMAT 999999999.99
COLUMN LUN          HEADING  "LUN (GB)"   FORMAT 999999999.99

SELECT *
FROM(SELECT SYS_CONTEXT('USERENV', 'SERVER_HOST')||'_ASM' SERVER
           , name DISKGROUP
           , ROUND (total_mb/1024) AS TOTAL_GB
           , ROUND ((total_mb-free_mb)/1024) AS USED_GB
           , ROUND (free_mb/1024) AS FREE_GB
           , ROUND((total_mb - free_mb)*100 / total_mb) USED_PCT
           , (SELECT ROUND(OS_MB/1024) FROM v$asm_disk GROUP BY ROUND(OS_MB/1024)) AS LUN
           , CASE WHEN round((total_mb - free_mb)*100 / total_mb,0) BETWEEN 70 AND 80 THEN 'Warning'
                  WHEN round((total_mb - free_mb)*100 / total_mb,0) > 80 THEN 'Critical'
                  ELSE 'OK' END Alarm
      FROM v$asm_diskgroup
      WHERE TOTAL_MB < 1048576
      UNION
      SELECT SYS_CONTEXT('USERENV', 'SERVER_HOST')||'_ASM' SERVER
           , name DISKGROUP
           , ROUND (total_mb/1024) AS TOTAL_GB
           , ROUND ((total_mb-free_mb)/1024) AS USED_GB
           , ROUND (free_mb/1024) AS FREE_GB
           , ROUND((total_mb - free_mb)*100 / total_mb) USED_PCT
           , (SELECT ROUND(OS_MB/1024) FROM v$asm_disk GROUP BY ROUND(OS_MB/1024)) AS LUN
           , CASE WHEN round((total_mb - free_mb)*100 / total_mb,0) BETWEEN 80 AND 90 THEN 'Warning'
                  WHEN round((total_mb - free_mb)*100 / total_mb,0) > 90 THEN 'Critical'
                  ELSE 'OK' END Alarm
      FROM v$asm_diskgroup
      WHERE TOTAL_MB BETWEEN 1048576 AND 2097152
      UNION
      SELECT SYS_CONTEXT('USERENV', 'SERVER_HOST')||'_ASM' SERVER
           , name DISKGROUP
           , ROUND (total_mb/1024) AS TOTAL_GB
           , ROUND ((total_mb-free_mb)/1024) AS USED_GB
           , ROUND (free_mb/1024) AS FREE_GB
           , ROUND((total_mb - free_mb)*100 / total_mb) USED_PCT
           , (SELECT ROUND(OS_MB/1024) FROM v$asm_disk GROUP BY ROUND(OS_MB/1024)) AS LUN
           , CASE WHEN round((total_mb - free_mb)*100 / total_mb,0) BETWEEN 90 AND 95 THEN 'Warning'
                  WHEN round((total_mb - free_mb)*100 / total_mb,0) > 95 THEN 'Critical'
                  ELSE 'OK' END Alarm
      FROM v$asm_diskgroup
      WHERE TOTAL_MB > 2097152
	 );
