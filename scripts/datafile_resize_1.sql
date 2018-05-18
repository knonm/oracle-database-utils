-- Show datafiles which can be resized based on High Watermark (HWM)

SET VERIFY OFF
SET LINESIZE 300

COLUMN file_name FORMAT A80 WORD_WRAPPED
COLUMN smallest  FORMAT 999,990 HEADING "Smallest|Size|Poss."
COLUMN currsize  FORMAT 999,990 HEADING "Current|Size"
COLUMN savings   FORMAT 999,990 HEADING "Poss.|Savings"
COLUMN cmd       FORMAT A100 WORD_WRAPPED
BREAK ON report
compute sum of savings on report

COLUMN value NEW_VAL blksize

SELECT value
FROM   v$parameter
WHERE  name = 'db_block_size';

SELECT file_name,
       CEIL((NVL(hwm,1)*&&blksize)/1048576) smallest, -- 1024/1024 = 1048576
       CEIL(blocks*&&blksize/1048576) currsize,
       CEIL(blocks*&&blksize/1048576) -
       CEIL((NVL(hwm,1)*&&blksize)/1048576) savings
FROM   dba_data_files a,
       (SELECT file_id,
               MAX(block_id + blocks - 1) hwm -- High Water Mark
        FROM   dba_extents
        GROUP  BY file_id) b
WHERE  a.file_id = b.file_id(+);

SELECT 'alter database datafile ''' || file_name || ''' resize ' ||
       CEIL((NVL(hwm,1)*&&blksize)/1048576) || 'm;' cmd
FROM   dba_data_files a,
       (SELECT file_id,
               MAX(block_id+blocks-1) hwm
        FROM   dba_extents
        GROUP  BY file_id) b
WHERE  a.file_id = b.file_id (+)
AND    CEIL(blocks*&&blksize/1048576) -
       CEIL((NVL(hwm,1)*&&blksize)/1048576 ) > 0;
