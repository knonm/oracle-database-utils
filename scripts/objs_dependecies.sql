SET LINESIZE 300
SET PAGESIZE 100

WITH
dep AS (
SELECT d.owner,
       d.name,
       d.type,
       d.referenced_owner,
       d.referenced_name,
       d.referenced_type,
       LEVEL as lvl
FROM   dba_dependencies d
START WITH d.referenced_owner = 'OWNER1' AND d.referenced_name = 'TABLE1' AND d.referenced_type = 'TABLE'
CONNECT BY d.referenced_owner = PRIOR d.owner AND d.referenced_name = PRIOR d.name AND d.referenced_type = PRIOR d.type
UNION
SELECT d.owner,
       d.name,
       d.type,
       d.referenced_owner,
       d.referenced_name,
       d.referenced_type,
       LEVEL * -1 AS lvl
FROM   dba_dependencies d
START WITH d.owner = 'OWNER1' AND d.name = 'TABLE1' AND d.type = 'TABLE'
CONNECT BY PRIOR d.referenced_owner = d.owner AND PRIOR d.referenced_name = d.name AND PRIOR d.referenced_type = d.type
)
SELECT *
FROM   dep
ORDER  BY lvl DESC, owner ASC, type ASC, name ASC, referenced_owner ASC, referenced_type ASC, referenced_name ASC;
