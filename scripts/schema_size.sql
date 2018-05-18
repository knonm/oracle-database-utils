SET LINESIZE 300
SET PAGESIZE 100

COLUMN OWNER           HEADING "Schema"           FORMAT A30
COLUMN SEGMENT_NAME    HEADING "Segment Name"     FORMAT A25
COLUMN SEGMENT_TYPE    HEADING "Segment|Type"     FORMAT A18
COLUMN SEGMENT_SUBTYPE HEADING "Segment|Subtype"  FORMAT A12
COLUMN TOTAL_GB        HEADING "Total (GB)"       FORMAT 99999.99
COLUMN USED_GB         HEADING "Used (GB)"        FORMAT 99999.99
COLUMN PCT_USED        HEADING "Used (%)"         FORMAT 999.99
COLUMN FREE_GB         HEADING "Free (GB)"        FORMAT 99999.99
COLUMN PCT_FREE        HEADING "Free (%)"         FORMAT 999.99

ACCEPT pbIndex PROMPT 'Ignore indexes? (Y | N | Default: N): '

SELECT owner,
       segment_type,
       segment_subtype,
       ROUND(SUM(max_size)/1024/1024/1024, 2) total_gb,
       ROUND(SUM(bytes)/1024/1024/1024, 2) used_gb,
       ROUND((SUM(bytes)/(SUM(max_size)+0.00001))*100, 2) pct_used,
       ROUND((SUM(max_size)-SUM(bytes))/1024/1024/1024, 2) free_gb,
       ROUND(((SUM(max_size)-SUM(bytes))/(SUM(max_size)+0.00001))*100, 2) pct_free
FROM   dba_segments
WHERE  (NVL(UPPER('&pbIndex'), 'N') = 'Y' AND segment_type NOT LIKE '%INDEX%')
OR     (NVL(UPPER('&pbIndex'), 'N') = 'N')
GROUP  BY ROLLUP(owner,
                 segment_type,
                 segment_subtype)
ORDER  BY owner, segment_type, segment_subtype;

UNDEFINE pbIndex
