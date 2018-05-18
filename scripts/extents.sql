select min(BLOCK_ID), max(BLOCK_ID), extent_id  from dba_extents where tablespace_name='TBSP_NAME' group by  extent_id order by extent_id, 1
select count(segment_name), EXTENT_ID from dba_extents where tablespace_name='TBSP_NAME' group by EXTENT_ID

select segment_name, blocks, block_id from dba_extents where tablespace_name ='TBSP_NAME' and extent_id=21

select min(BLOCK_ID), max((BLOCK_ID+blocks)-1), extent_id  from dba_extents where tablespace_name='TBSP_NAME' group by  extent_id order by extent_id, 1

--

SELECT e1.block_id, e1.blocks, e1.extent_id, e1.segment_name, e1.segment_type
FROM   dba_extents e1
WHERE  e1.tablespace_name = 'TBSP_NAME'
AND    NOT EXISTS
       (SELECT e2.block_id
        FROM   dba_extents e2
        WHERE  e2.tablespace_name = e1.tablespace_name
        AND    e2.block_id = (e1.block_id + e1.blocks))
ORDER  BY 1 ASC, e1.extent_id ASC;

SELECT file_id,
       tablespace_name
FROM   dba_data_files
WHERE  tablespace_name = 'TBSP_NAME';

SELECT SUM(blocks) AS sum_blocks,
       (MAX(block_id + blocks - 1)) AS high_water_mark
FROM   dba_extents
WHERE  tablespace_name = 'TBSP_NAME';

SET LINESIZE 300
COLUMN segment_name FORMAT A40
SELECT PRIOR block_id AS prior_block_id,
       PRIOR blocks AS prior_blocks,
       block_id,
       blocks,
       block_id - (PRIOR block_id + PRIOR blocks) AS gap_blocks,
       extent_id,
       segment_name,
       segment_type,
       file_id
FROM   (SELECT block_id,
               blocks,
               extent_id,
               segment_name,
               segment_type,
               file_id,
               ROWNUM AS r
        FROM   (SELECT block_id,
                       blocks,
                       extent_id,
                       segment_name,
                       segment_type,
                       file_id
                FROM   dba_extents
                WHERE  tablespace_name = 'TBSP_NAME'
                ORDER  BY block_id ASC))
START WITH r = 1
CONNECT BY PRIOR r + 1 = r;
