SELECT a.UNIQUE_NAME,
       a.SEQ_APPLIED     AS "SEQ_APPLIED_PRIMARY",
       b.SEQ_APPLIED     AS "SEQ_APPLIED_STANDBY",
       a.first_time      AS "DATE_PRIMARY",
       a.COMPLETION_TIME AS "COMPLETION_TIME_PRIMARY",
       b.first_time      AS "DATE_STANDBY",
       b.COMPLETION_TIME AS "COMPLETION_TIME_STANDBY"
FROM   (SELECT DISTINCT UPPER(c.db_unique_name) "UNIQUE_NAME",
               c.type,
               b.sequence# "SEQ_APPLIED",
               c.database_mode,
               b.dest_id,
               b.first_time,
               b.COMPLETION_TIME
        FROM   v$database_incarnation a,
               v$archived_log b,
               v$archive_dest_status c
        WHERE  c.DB_UNIQUE_NAME <> 'NONE'
        AND    c.TYPE = 'LOCAL'
        AND    c.dest_id = b.dest_id
        AND    b.resetlogs_id = a.resetlogs_id
        AND    a.status = 'CURRENT'
        AND    TRUNC(b.first_time, 'DD') = TRUNC(SYSDATE, 'DD')) a,
       (SELECT DISTINCT UPPER(c.db_unique_name),
               c.type,
               b.sequence# "SEQ_APPLIED",
               c.database_mode,
               b.dest_id,
               b.first_time,
               b.COMPLETION_TIME
        FROM   v$database_incarnation a,
               v$archived_log b,
               v$archive_dest_status c
        WHERE  UPPER(c.DB_UNIQUE_NAME) = UPPER('db_unique_name')||'AG'
        AND    c.TYPE <> 'LOCAL'
        AND    b.applied = 'YES'
        AND    c.dest_id = b.dest_id
        AND    b.resetlogs_id = a.resetlogs_id
        AND    a.status = 'CURRENT'
        AND    TRUNC(b.first_time, 'DD') = TRUNC(SYSDATE, 'DD')) b
WHERE  a.SEQ_APPLIED = b.SEQ_APPLIED (+)
ORDER  BY a.first_time DESC;
