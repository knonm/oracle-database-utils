SET LINESIZE 300
SET PAGESIZE 0
SET HEADING OFF
SET FEEDBACK OFF
SET TRIMSPOOL ON
SET VERIFY OFF
SET ECHO OFF

ACCEPT pcUser PROMPT "User: "

SPOOL userclone_output.sql

PROMPT CREATE USER &pcUser IDENTIFIED BY &pcUser;;

SELECT 'ALTER USER ' || UPPER(a.username) || ' IDENTIFIED ' || DECODE(a.authentication_type, 'PASSWORD', 'BY VALUES ''' || b.password || '''', a.authentication_type) ||
       DECODE(a.default_tablespace, NULL, '', ' DEFAULT TABLESPACE ' || a.default_tablespace) ||
       DECODE(a.temporary_tablespace, NULL, '', ' TEMPORARY TABLESPACE ' || a.temporary_tablespace) ||
       DECODE(a.profile, NULL, '', ' PROFILE ' || a.profile) ||
       ';'
FROM   dba_users a,
       user$ b
WHERE  UPPER(a.username) = UPPER('&pcUser')
AND    UPPER(a.username) = UPPER(b.name);

SELECT 'ALTER USER ' || UPPER(a.username) || ' QUOTA ' || DECODE(a.max_bytes, -1, 'UNLIMITED', TO_CHAR(a.bytes)) || ' ON ' || a.tablespace_name || ';'
FROM   dba_ts_quotas a
WHERE  UPPER(a.username) = UPPER('&pcUser');

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
SELECT 'GRANT ' || privilege || DECODE(table_name, NULL, ' ', ' ON ' || table_name || DECODE(column_name, NULL, '', '.' || column_name)) ||
       'TO ' || grantee || DECODE(options, 'YES', DECODE(lvl, 'ROLE', ' WITH ADMIN OPTION', DECODE(lvl, 'SYS PRIV', ' WITH ADMIN OPTION', ' WITH GRANT OPTION'))) || ';' AS cmd
FROM   privs
WHERE  UPPER(grantee) = UPPER('&pcUser')
ORDER  BY grantee    ASC,
          lvl        ASC,
          privilege  ASC,
          owner      ASC,
          table_name ASC;

SPOOL OFF

UNDEF pcUser
