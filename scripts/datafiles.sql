-- Datafiles info

SET LINESIZE 300
SET VERIFY OFF

COLUMN file_name       HEADING "File Name"         FORMAT A60
COLUMN tablespace_name HEADING "Tablespace Name"   FORMAT A30
COLUMN size            HEADING "Size (MB)"
COLUMN maxbytes        HEADING "Max Size (MB)"
COLUMN blocks          HEADING "Blocks"
COLUMN maxblocks       HEADING "Max Blocks"
COLUMN kbpb            HEADING "KB/Blocks"
COLUMN status          HEADING "Status"            FORMAT A9
COLUMN autoextensible  HEADING "Auto Extensible?"  FORMAT A16
COLUMN increment_by    HEADING "Increment By (KB)"

ACCEPT vcTbsp PROMPT 'Tablespace name: '

SELECT SUBSTR(file_name, 1, 60) AS file_name,
       tablespace_name          AS tablespace_name,
       (bytes/1024/1024)        AS "size",
       (maxbytes/1024/1024)     AS maxbytes,
       blocks                   AS blocks,
       (maxblocks/1024/1024)    AS maxblocks,
       (bytes/1024)/blocks      AS kbpb,
       status                   AS status,
       autoextensible           AS autoextensible,
       (increment_by/1024)      AS increment_by
FROM   dba_data_files
WHERE  UPPER(tablespace_name) LIKE '%' || UPPER(NVL('&vcTbsp', tablespace_name)) || '%'
ORDER  BY file_name ASC,
          tablespace_name ASC;

UNDEFINE vcTbsp
