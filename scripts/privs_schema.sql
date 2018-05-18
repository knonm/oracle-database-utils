SET LINESIZE 450

COLUMN grantee HEADING "Role/Schema"
COLUMN table_name HEADING "Table Name"
COLUMN priv HEADING "Privilege"

-- Schema privileges
SELECT 'SCHEMA' AS grantee,
       t.table_name AS table_name,
	     '&&priv' AS priv
FROM   dba_tables t
WHERE  t.OWNER = 'SCHEMA'
AND    NOT EXISTS (SELECT 1
                   FROM   dba_tab_privs dtp
                   WHERE  dtp.owner = t.owner
                   AND    dtp.table_name = t.table_name
                   AND    dtp.grantee = 'SCHEMA'
                   AND    dtp.privilege = '&&priv')
ORDER  BY grantee;
