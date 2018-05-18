SET LINESIZE 200

COLUMN sql_text     FORMAT A100  HEADING Sql     word wrap
COLUMN child_number FORMAT 99999 HEADING Child#

ACCEPT v_sqlid PROMPT "Entre with SQLID: "

SELECT s.child_number,
       t.sql_text
FROM   v$sqltext t,
       v$sql s
WHERE  s.sql_id = '&v_sqlid'
AND    s.address = t.address
AND    s.hash_value = t.hash_value
ORDER  BY s.child_number,
          t.piece;
