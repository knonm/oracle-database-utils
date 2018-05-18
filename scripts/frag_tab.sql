SET LINESIZE 300
SET PAGESIZE 200

COLUMN partition_name FORMAT A10
COLUMN subpartition_name FORMAT A15

SELECT t1.owner, t1.table_name, t2.partition_name, t3.subpartition_name,
       t1.blocks, t1.num_rows, t1.avg_row_len, t1.pct_free, DECODE(NVL(t1.blocks, 0) * 8192, 0, 1, 1-((t1.avg_row_len * t1.num_rows)/(t1.blocks * 8192))) as frag1,
       t2.blocks, t2.num_rows, t2.avg_row_len, t2.pct_free, DECODE(NVL(t2.blocks, 0) * 8192, 0, 1, 1-((t2.avg_row_len * t2.num_rows)/(t2.blocks * 8192))) as frag2,
       t3.blocks, t3.num_rows, t3.avg_row_len, t3.pct_free, DECODE(NVL(t3.blocks, 0) * 8192, 0, 1, 1-((t3.avg_row_len * t3.num_rows)/(t3.blocks * 8192))) as frag3
FROM   dba_tables t1,
       dba_tab_partitions t2,
       dba_tab_subpartitions t3
WHERE  t1.owner = t2.table_owner (+)
AND    t1.table_name = t2.table_name (+)
AND    t2.table_owner = t3.table_owner (+)
AND    t2.table_name = t3.table_name (+)
AND    t2.partition_name = t3.partition_name (+)
AND    t1.owner LIKE 'OWNER%'
ORDER  BY 1, 2, 3, 4;
