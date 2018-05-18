SET LINESIZE 300
SET PAGESIZE 100
SET VERIFY OFF

COLUMN OWNER           HEADING "Schema"           FORMAT A30
COLUMN SEGMENT_NAME    HEADING "Segment Name"     FORMAT A25
COLUMN SEGMENT_TYPE    HEADING "Segment|Type"     FORMAT A18
COLUMN SEGMENT_SUBTYPE HEADING "Segment|Subtype"  FORMAT A12
COLUMN USED_MB         HEADING "Size (MB)"        FORMAT 99999.99

ACCEPT pcOwner   PROMPT 'Owner: '
ACCEPT pcSegName PROMPT 'Segment Name: '
ACCEPT pcSegType PROMPT 'Segment Type: '
ACCEPT pcIndex   PROMPT 'Ignore Index? (YES / NO): '

SELECT owner,
       segment_name,
       segment_type,
       segment_subtype,
       ROUND(SUM(bytes)/1024/1024, 2) used_mb
FROM   dba_segments
WHERE  owner        LIKE NVL(UPPER('%' || '&pcOwner' || '%'), owner)
AND    segment_name LIKE NVL(UPPER('%' || '&pcSegName' || '%'), segment_name)
AND    segment_type LIKE NVL(UPPER('%' || '&pcSegType' || '%'), segment_type)
AND    segment_type NOT LIKE DECODE(NVL(UPPER('&pcIndex'), 'NO'), 'YES', '%INDEX%', segment_type || '#')
GROUP  BY owner,
          segment_name,
          segment_type,
          segment_subtype;

UNDEFINE pcOwner
UNDEFINE pcSegName
UNDEFINE pcSegType
UNDEFINE pcIndex
