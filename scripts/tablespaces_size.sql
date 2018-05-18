SET LINESIZE 300
SET PAGESIZE 50
SET VERIFY OFF

COLUMN tablespace_name HEADING "Tablespace Name"
COLUMN size_gb         HEADING "Size (GB)"

ACCEPT pcTbsp PROMPT "Tablespace name: "

SELECT tablespace_name           AS tablespace_name,
       SUM(bytes)/1024/1024/1024 AS size_gb
FROM   dba_free_space
WHERE  tablespace_name = NVL('&pcTbsp', tablespace_name)
GROUP  BY tablespace_name
ORDER  BY 1;

UNDEF pcTbsp
