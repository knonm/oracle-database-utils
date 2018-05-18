SET LINESIZE 450

COLUMN grantee HEADING "Role/Schema"
COLUMN table_name HEADING "Table Name"
COLUMN priv HEADING "Privilege"

-- Role privileges
SELECT 'ROLE'  AS grantee,
       t.table_name AS table_name,
	     '&&priv'     AS priv
FROM   dba_tables t
WHERE  t.owner = 'OWNER'
AND    NOT EXISTS (SELECT 1
                   FROM   role_tab_privs rtp
                   WHERE  rtp.owner = t.owner
                   AND    rtp.table_name = t.table_name
                   AND    UPPER(rtp.role) = 'ROLE'
                   AND    rtp.privilege = '&&priv')
ORDER  BY grantee ASC;
