SET VERIFY OFF
SET FEEDBACK OFF
SET PAGESIZE 100
SET LINESIZE 300

COLUMN owner       HEADING "Schema"
COLUMN object_name HEADING "Obj. Name"
COLUMN object_type HEADING "Obj. Type"
COLUMN status      HEADING "Status"

ACCEPT pcOwner  PROMPT 'Schema: '
ACCEPT pcType   PROMPT 'Obj. Type: '
ACCEPT pcName   PROMPT 'Obj. Name: '
ACCEPT pcStatus PROMPT 'Status: '

SELECT owner,
       object_name,
       object_type,
       status
FROM   dba_objects
WHERE  UPPER(owner)       LIKE '%' || UPPER(NVL('%&pcOwner%', owner)) || '%'
AND    UPPER(object_type) LIKE '%' || UPPER(NVL('%&pcType%', object_type)) || '%'
AND    UPPER(object_name) LIKE '%' || UPPER(NVL('%&pcName%', object_name)) || '%'
AND    UPPER(status)      LIKE '%' || UPPER(NVL('%&pcStatus%', status)) || '%'
ORDER  BY object_type ASC,
          object_name ASC;

UNDEF pcOwner
UNDEF pcType
UNDEF pcStatus
