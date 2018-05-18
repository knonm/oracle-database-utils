SET PAGESIZE 0
SET LINESIZE 200
SET HEADING OFF
SET FEEDBACK OFF
SET VERIFY OFF

WITH privs AS
(
SELECT 'Column Privs' AS lvl,
       c.privilege    AS privilege,
       c.grantable    AS options,
       c.grantee      AS grantee,
       c.owner        AS owner,
       c.table_name   AS table_name,
       c.column_name  AS column_name
FROM   dba_col_privs c,
       dba_objects o
WHERE  c.owner = o.owner
AND    c.table_name = o.object_name
UNION
SELECT 'Role Privs'   AS lvl,
       r.granted_role AS privilege,
       r.admin_option AS options,
       r.grantee      AS grantee,
       NULL           AS owner,
       NULL           AS table_name,
       NULL           AS column_name
FROM   dba_role_privs r
UNION
SELECT 'System Privs' AS lvl,
       s.privilege    AS privilege,
       s.admin_option AS options,
       s.grantee      AS grantee,
       NULL           AS owner,
       NULL           AS table_name,
       NULL           AS column_name
FROM   dba_sys_privs s
UNION
SELECT 'Program Privs' AS lvl,
       e.privilege     AS privilege,
       e.grantable     AS options,
       e.grantee       AS grantee,
       e.owner         AS owner,
       e.table_name    AS table_name,
       NULL            AS column_name
FROM   dba_tab_privs e,
       dba_objects o
WHERE  e.owner = o.owner
AND    e.table_name = o.object_name
)
SELECT p.grantee || ';' ||
       DECODE(r.role, NULL, 'USER', 'ROLE') || ';' ||
       TO_CHAR(u.ctime, 'DD/MM/YYYY HH24:MI:SS') || ';' ||
       p.lvl || ';' ||
       p.privilege || ';' ||
       p.options || ';' ||
       p.owner || ';' ||
       p.table_name || ';' ||
       p.column_name
FROM   privs p,
       dba_roles r,
       user$ u
WHERE  p.grantee = r.role (+)
AND    p.grantee = u.name
ORDER  BY p.grantee    ASC,
          p.lvl        ASC,
          p.privilege  ASC,
          p.owner      ASC,
          p.table_name ASC;

EXIT
