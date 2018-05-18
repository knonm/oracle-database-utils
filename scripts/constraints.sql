SET LINESIZE 300

COLUMN owner FORMAT A10
COLUMN r_owner FORMAT A10
COLUMN constraint_name FORMAT A25
COLUMN r_constraint_name FORMAT A25
COLUMN search_condition FORMAT A30
COLUMN column_name FORMAT A15
COLUMN table_name FORMAT A25

SELECT c.owner,
       c.constraint_name,
       c.constraint_type,
       c.table_name,
       c.r_owner,
       c.r_constraint_name,
       c.search_condition,
       c.status,
       cc.column_name
FROM   dba_constraints c,
       dba_cons_columns cc
WHERE  c.owner = cc.owner (+)
AND    c.constraint_name = cc.constraint_name (+)
AND    c.owner = 'OWNER'
ORDER  BY c.owner ASC,
          c.constraint_type ASC,
          c.constraint_name ASC,
          cc.position ASC;
