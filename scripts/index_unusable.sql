SET LINESIZE 300

SELECT i.owner      AS owner,
       i.index_name AS index_name,
       ''           AS partition_name,
       ''           AS subpartition_name,
       i.status     AS status
FROM   dba_indexes i
WHERE  i.status = 'UNUSABLE'
UNION
SELECT i.index_owner    AS owner,
       i.index_name     AS index_name,
       i.partition_name AS partition_name,
       ''               AS subpartition_name,
       i.status         AS status
FROM   dba_ind_partitions i
WHERE  i.status = 'UNUSABLE'
UNION
SELECT i.index_owner       AS owner,
       i.index_name        AS index_name,
       i.partition_name    AS partition_name,
       i.subpartition_name AS subpartition_name,
       i.status            AS status
FROM   dba_ind_subpartitions i
WHERE  i.status = 'UNUSABLE';
