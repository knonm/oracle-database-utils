SET LINESIZE 300
SET PAGESIZE 0
SET HEADING OFF
SET FEEDBACK OFF
SET TRIMSPOOL ON
SET VERIFY OFF
SET ECHO OFF

COLUMN "cmd" FORMAT A1000

ACCEPT pcGrantee PROMPT 'Grantee: '

SPOOL export_grants_spool.sql

SELECT 'GRANT ' || c.privilege || ' (' || c.column_name || ') ' || 'ON "' || c.owner || '"."' || c.table_name || '" TO ' || UPPER('&pcGrantee') || DECODE(c.grantable, 'YES', ' WITH GRANT OPTION', '') || ';' AS "cmd"
FROM   dba_col_privs c
WHERE  grantee = UPPER('&pcGrantee')
UNION
SELECT 'GRANT ' || r.granted_role || ' TO ' || UPPER('&pcGrantee') || DECODE(r.admin_option, 'YES', ' WITH ADMIN OPTION', '') || ';' AS "cmd"
FROM   dba_role_privs r
WHERE  r.grantee = UPPER('&pcGrantee')
UNION
SELECT 'GRANT ' || s.privilege || ' TO ' || UPPER('&pcGrantee') || DECODE(s.admin_option, 'YES', ' WITH ADMIN OPTION', '') || ';' AS "cmd"
FROM   dba_sys_privs s
WHERE  s.grantee = UPPER('&pcGrantee')
UNION
SELECT 'GRANT ' || e.privilege || ' ON "' || e.owner || '"."' || e.table_name || '" TO ' || UPPER('&pcGrantee') || DECODE(e.grantable, 'YES', ' WITH GRANT OPTION', '') || ';' AS "cmd"
FROM   dba_tab_privs e
WHERE  e.grantee = UPPER('&pcGrantee');

SPOOL OFF

UNDEFINE pcGrantee
