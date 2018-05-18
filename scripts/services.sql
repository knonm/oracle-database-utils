SET LINESIZE 300
SET PAGESIZE 50
SET VERIFY OFF

ACCEPT pcBlocked PROMPT "Blocked? (Y | N): "
ACCEPT pcActive  PROMPT "Active? (Y | N): "

COLUMN service_id HEADING "Service ID"
COLUMN name HEADING "Name"
COLUMN network_name HEADING "Network Name" FORMAT A60
COLUMN creation HEADING "Creation Date" FORMAT A19
COLUMN blocked HEADING "Blocked?" FORMAT A8
COLUMN active HEADING "Active?" FORMAT A7

SELECT *
FROM   (
SELECT service_id,
       name,
       network_name,
       TO_CHAR(creation_date, 'YYYY-MM-DD HH24:MI:SS') creation,
       blocked,
       'YES' active
FROM   v$active_services
UNION
SELECT ds.service_id,
       ds.name,
       ds.network_name,
       TO_CHAR(ds.creation_date, 'YYYY-MM-DD HH24:MI:SS') creation,
       'NO' blocked,
       'NO' active
FROM   dba_services ds
WHERE  NOT EXISTS
(SELECT 1
 FROM   v$active_services vas
 WHERE  vas.service_id = ds.service_id)
)
WHERE blocked = NVL('&pcBlocked', blocked)
AND   active = NVL('&pcActive', active);

UNDEF pcBlocked
UNDEF pcActive