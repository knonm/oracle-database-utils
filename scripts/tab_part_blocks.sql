SELECT t.blocks, p.blocks, s.blocks
FROM   dba_tables t,
       dba_tab_partitions p,
       dba_tab_subpartitions s
WHERE  t.owner = p.table_owner
AND    t.table_name = p.table_name
AND    p.table_owner = s.table_owner (+)
AND    p.table_name = s.table_name (+)
AND    p.partition_name = s.partition_name (+)
AND    t.owner = '&1';