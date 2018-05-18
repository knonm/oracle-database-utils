-- ASM DG size
-- Execute as "sysasm" profile -> sqlplus / as sysasm

SET LINESIZE 300
SET PAGESIZE 100

COLUMN GROUP_NUMBER HEADING "Group Number"
COLUMN NAME HEADING "DG Name"
COLUMN STATE HEADING "State"
COLUMN TOTAL_GB HEADING "Total (GB)" FORMAT 999999999.99
COLUMN USED_GB HEADING "Used (GB)"   FORMAT 999999999.99
COLUMN USED_PCT HEADING "Used (%)"   FORMAT 999.99
COLUMN FREE_GB HEADING "Free (GB)"   FORMAT 999999999.99
COLUMN FREE_PCT HEADING "Free (%)"   FORMAT 999.99

SELECT a.group_number                                    AS group_number,
       a.name                                            AS name,
       a.state                                           AS state,
       ROUND(a.total_mb/1024, 2)                         AS total_gb,
       ROUND((a.total_mb-a.free_mb)/1024, 2)             AS used_gb,
       ROUND(((a.total_mb-a.free_mb)/a.total_mb)*100, 2) AS used_pct,
       ROUND(a.free_mb/1024, 2)                          AS free_gb,
       ROUND((a.free_mb/a.total_mb)*100, 2)              AS free_pct
FROM   v$asm_diskgroup a
ORDER  BY used_pct DESC;
