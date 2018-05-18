SET LINESIZE 300

COLUMN owner HEADING "Schema"
COLUMN tablespace_name HEADING "Tablespace"

ACCEPT p_owner PROMPT "Schemas (e.g. 'SCHEMA1', 'SCHEMA2', 'SCHEMA3'): "

SELECT DISTINCT
       owner,
       tablespace_name
FROM   (SELECT owner,
               tablespace_name
        FROM   dba_segments
        WHERE  owner IN (&p_owner)
        UNION
        SELECT username AS owner,
               default_tablespace AS tablespace_name
        FROM   dba_users
        WHERE  username IN (&p_owner));
