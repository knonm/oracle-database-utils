COLUMN owner              FORMAT A10
COLUMN obj_name           FORMAT A10
COLUMN extended_timestamp FORMAT A35

SELECT dat.username,
       dat.extended_timestamp,
       dat.owner,
       dat.obj_name,
       dat.action_name
FROM   dba_audit_trail dat
WHERE  dat.extended_timestamp BETWEEN TO_DATE('10032107 10:00','DDMMYYYY HH24:MI') AND TO_DATE('10032107 13:20','DDMMYYYY HH24:MI')
ORDER  BY dat.timestamp;
