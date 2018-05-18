-- ASM DGs disks size
-- Execute as "sysasm" profile -> sqlplus / as sysasm

SET LINESIZE 300
SET PAGESIZE 100

COLUMN NAME_DG HEADING "Nome DG"
COLUMN DISK_NUMBER HEADING "Num. do Disco"
COLUMN NAME_DISK HEADING "Nome do Disco"
COLUMN TOTAL_GB HEADING "Total (GB)" FORMAT 999999999.99
COLUMN USED_GB HEADING "Used (GB)"   FORMAT 999999999.99
COLUMN USED_PCT HEADING "Used (%)"   FORMAT 999.99
COLUMN FREE_GB HEADING "Free (GB)"   FORMAT 999999999.99
COLUMN FREE_PCT HEADING "Free (%)"   FORMAT 999.99
COLUMN PATH HEADING "Path"           FORMAT A60

SELECT a.name                                            AS name_dg,
       b.disk_number                                     AS disk_number,
       b.name                                            AS name_disk,
       b.path                                            AS path,
       ROUND(b.total_mb/1024, 2)                         AS total_gb,
       ROUND((b.total_mb-b.free_mb)/1024, 2)             AS used_gb,
       ROUND(((b.total_mb-b.free_mb)/b.total_mb)*100, 2) AS used_pct,
       ROUND(b.free_mb/1024, 2)                          AS free_gb,
       ROUND((b.free_mb/b.total_mb)*100, 2)              AS free_pct,
       b.header_status
FROM   v$asm_diskgroup a,
       v$asm_disk b
WHERE  a.group_number = b.group_number
ORDER  BY used_pct DESC;
