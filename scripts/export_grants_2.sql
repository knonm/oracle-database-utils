SET LINESIZE 300
SET PAGESIZE 0
SET HEADING OFF
SET FEEDBACK OFF
SET TRIMSPOOL ON
SET VERIFY OFF
SET ECHO OFF

COLUMN "cmd_grant" FORMAT A1000

SPOOL export_grants_spool.sql

PROMPT "SET ECHO ON"

PROMPT ""

WITH
grants AS (
SELECT grantee,
       'GRANT ' || privilege || ' (' || SUBSTR(SYS_CONNECT_BY_PATH(column_name, '", "'), 4) ||
       '") ON "' || owner || '"."' || table_name || '" TO ' || grantee ||
       DECODE(grantable, 'NO', '', 'YES', ' WITH GRANT OPTION', '') || ';' AS cmd_grant
FROM (
SELECT grantee,
       privilege,
       owner,
       table_name,
       column_name,
       grantable,
       ROW_NUMBER() OVER (PARTITION BY grantee, privilege, owner, table_name ORDER BY grantee, owner, table_name, privilege)     AS curr,
       ROW_NUMBER() OVER (PARTITION BY grantee, privilege, owner, table_name ORDER BY grantee, owner, table_name, privilege) - 1 AS prev
FROM   dba_col_privs
)
WHERE CONNECT_BY_ISLEAF = 1
CONNECT BY prev = PRIOR curr
AND        grantee = PRIOR grantee
AND        privilege = PRIOR privilege
AND        owner = PRIOR owner
AND        table_name = PRIOR table_name
START WITH curr = 1
UNION
SELECT grantee,
       'GRANT ' || privilege || ' ON "' || owner || '"."' || table_name ||
       '" TO ' || grantee ||
       DECODE(hierarchy, 'NO', '', 'YES', ' WITH HIERARCHY OPTION', '') ||
       DECODE(grantable, 'NO', '', 'YES', ' WITH GRANT OPTION', '') || ';' AS cmd_grant
FROM   dba_tab_privs e
UNION
SELECT grantee,
       'GRANT ' || privilege || ' TO ' || grantee ||
       DECODE(admin_option, 'NO', '', 'YES', ' WITH ADMIN OPTION', '') || ';' AS cmd_grant
FROM   dba_sys_privs s
UNION
SELECT grantee,
       'GRANT ' || granted_role || ' TO ' || grantee ||
       DECODE(admin_option, 'NO', '', 'YES', ' WITH ADMIN OPTION', '') || ';' AS cmd_grant
FROM   dba_role_privs s
)
SELECT cmd_grant
FROM   grants
WHERE  grantee IN
('SCHEMA1',
 'SCHEMA2',
 'SCHEMA3');

SPOOL OFF
