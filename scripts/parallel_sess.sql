COLUMN "username"   FORMAT A12
COLUMN "QC SID"     FORMAT A6
COLUMN "SID"        FORMAT A6
COLUMN "QC/Slave"   FORMAT A8
COLUMN "Req. DOP"   FORMAT 9999
COLUMN "Actual DOP" FORMAT 9999
COLUMN "Slaveset"   FORMAT A8
COLUMN "Slave INST" FORMAT A9
COLUMN "QC INST"    FORMAT A6
COLUMN "STATE"      FORMAT A12
COLUMN "program"    FORMAT A40
COLUMN "wait_event" FORMAT A30

SET PAGESIZE 300
SET LINESIZE 300

SELECT DECODE(px.qcinst_id, NULL, username, ' - ' || LOWER(SUBSTR(pp.SERVER_NAME, LENGTH(pp.SERVER_NAME) - 4, 4))) AS "username",
       s.program AS "program",
       DECODE(px.qcinst_id, NULL, 'QC', '(Slave)') AS "QC/Slave" ,
       TO_CHAR( px.server_set) AS "SlaveSet",
       TO_CHAR(s.sid) AS "SID",
       TO_CHAR(px.inst_id) AS "Slave INST",
       DECODE(sw.state, 'WAITING', 'WAIT', 'NOT WAIT') AS "STATE",
       CASE sw.state WHEN 'WAITING' THEN SUBSTR(sw.event, 1, 30) ELSE NULL END AS "wait_event",
       DECODE(px.qcinst_id, NULL ,TO_CHAR(s.sid) ,px.qcsid) AS "QC SID",
       TO_CHAR(px.qcinst_id) AS "QC INST",
       px.req_degree AS "Req. DOP",
       px.degree AS "Actual DOP"
FROM   gv$px_session px,
       gv$session s ,
       gv$px_process pp,
       gv$session_wait sw
WHERE  px.sid = s.sid (+)
AND    px.serial# = s.serial# (+)
AND    px.inst_id = s.inst_id (+)
AND    px.sid = pp.sid (+)
AND    px.serial# = pp.serial# (+)
AND    sw.sid = s.sid
AND    sw.inst_id = s.inst_id
ORDER  BY DECODE(px.QCINST_ID, NULL, px.INST_ID, px.QCINST_ID),
          px.QCSID,
          DECODE(px.SERVER_GROUP, NULL, 0, px.SERVER_GROUP),
          px.SERVER_SET,
          px.INST_ID;
