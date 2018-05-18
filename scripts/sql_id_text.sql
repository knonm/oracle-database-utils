SELECT sql_id,
       child_number
FROM   v$sql
WHERE  sql_text LIKE '%TIME_WAITED_MICRO from V$SYSTEM_EVENT%';

SELECT DISTINCT ADDRESS,
       HASH_VALUE,
       sql_id,
       plan_hash_value,
       child_number,
       COST,
       ELAPSED_TIME,
       LAST_EXECUTION,
       TOTAL_EXECUTIONS,
       TIMESTAMP
FROM   V$SQL_PLAN_STATISTICS_ALL
WHERE  sql_id = 'sqlid';

SELECT SQL_ID,
       PLAN_HASH_VALUE,
       ACTION,
       SQL_PROFILE,
       TIMESTAMP
FROM   DBA_HIST_SQLSTAT
WHERE  sql_id = 'sqlid';
