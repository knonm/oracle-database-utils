-- The following script shows privileges granted to a user, as well as the level, object, and object owner.

SET ECHO off

SET VERIFY   OFF
SET PAGESIZE 20
SET LINESIZE 300

COLUMN lvl             HEADING "Type"                        FORMAT A30
COLUMN privilege       HEADING "Privilege"                   FORMAT A30
COLUMN options         HEADING "Grantable / Admin Options ?" FORMAT A27
COLUMN grantee         HEADING "Grantee"                     FORMAT A20
COLUMN grantee_type    HEADING "Grantee Type"                FORMAT A15
COLUMN grantee_created HEADING "Grantee Created"             FORMAT A19
COLUMN owner           HEADING "Obj. Owner"                  FORMAT A20
COLUMN table_name      HEADING "Obj. Name"                   FORMAT A20
COLUMN column_name     HEADING "Col. Name"                   FORMAT A20

ACCEPT pcGrantee PROMPT 'Grantee (owner que possui o privilegio): '
ACCEPT pcLvl     PROMPT 'Level (ROLE / SYS PRIV / OBJ_TYPE_NAME /  OBJ_TYPE_NAME COLUMN): '
ACCEPT pcPriv    PROMPT 'Privilege: '
ACCEPT pcOwner   PROMPT 'Owner: '
ACCEPT pcObjName PROMPT 'Object Name: '

WITH privs AS
(
SELECT o.object_type || ' COLUMN' AS lvl,
       c.privilege                AS privilege,
       c.grantable                AS options,
       c.grantee                  AS grantee,
       c.owner                    AS owner,
       c.table_name               AS table_name,
       c.column_name              AS column_name
FROM   dba_col_privs c,
       dba_objects o
WHERE  c.owner = o.owner
AND    c.table_name = o.object_name
UNION
SELECT 'ROLE'         AS lvl,
       r.granted_role AS privilege,
       r.admin_option AS options,
       r.grantee      AS grantee,
       NULL           AS owner,
       NULL           AS table_name,
       NULL           AS column_name
FROM   dba_role_privs r
UNION
SELECT 'SYS PRIV'     AS lvl,
       s.privilege    AS privilege,
       s.admin_option AS options,
       s.grantee      AS grantee,
       NULL           AS owner,
       NULL           AS table_name,
       NULL           AS column_name
FROM   dba_sys_privs s
UNION
SELECT o.object_type AS lvl,
       e.privilege   AS privilege,
       e.grantable   AS options,
       e.grantee     AS grantee,
       e.owner       AS owner,
       e.table_name  AS table_name,
       NULL          AS column_name
FROM   dba_tab_privs e,
       dba_objects o
WHERE  e.owner = o.owner
AND    e.table_name = o.object_name
)
SELECT p.lvl,
       p.privilege,
       p.options,
       p.grantee,
       DECODE(r.role, NULL, 'Role', 'User') AS grantee_type,
       TO_CHAR(u.ctime, 'DD/MM/YYYY HH24:MI:SS') AS grantee_created,
       p.owner,
       p.table_name,
       p.column_name
FROM   privs p,
       dba_roles r,
       user$ u
WHERE  p.grantee = r.role (+)
AND    p.grantee = u.name
AND    NVL(UPPER(p.grantee), '#')    = UPPER(COALESCE('&pcGrantee', p.grantee, '#'))
AND    NVL(UPPER(p.lvl), '#')        LIKE '%' || UPPER(COALESCE('&pcLvl', p.lvl, '#')) || '%'
AND    NVL(UPPER(p.privilege), '#')  LIKE '%' || UPPER(COALESCE('&pcPriv', p.privilege, '#')) || '%'
AND    NVL(UPPER(p.owner), '#')      LIKE '%' || UPPER(COALESCE('&pcOwner', p.owner, '#')) || '%'
AND    NVL(UPPER(p.table_name), '#') LIKE '%' || UPPER(COALESCE('&pcObjName', p.table_name, '#')) || '%'
ORDER  BY p.grantee    ASC,
          p.lvl        ASC,
          p.privilege  ASC,
          p.owner      ASC,
          p.table_name ASC;

UNDEFINE pcGrantee
UNDEFINE pcLvl
UNDEFINE pcPriv
UNDEFINE pcOwner
UNDEFINE pcObjName
