SET LINESIZE 300

COLUMN name FORMAT A60

SELECT d.file#,
       d.name,
       d.status,
       ROUND((d.blocks*d.block_size)/1024/1024, 0) AS size_mb
FROM   v$datafile d
ORDER  BY d.file#;
