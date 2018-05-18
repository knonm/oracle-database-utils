-- 1. Enabled Resource_plan?
SELECT name, cpu_managed
FROM   v$rsrc_plan
WHERE  is_top_plan = 'TRUE';

-- 2. History of Plans enabled/disable with begin/end and window name. By default on 11g, there are  7 window name with automated tasks.
COLUMN start_time  FORMAT A20
COLUMN end_time    FORMAT A20
COLUMN name        FORMAT A40
COLUMN window_name FORMAT A25

SELECT name,
       to_char(start_time, 'YYYY MON DD HH24:MI') start_time,
       to_char(end_time, 'YYYY MON DD HH24:MI') end_time,
       window_name
FROM   v$rsrc_plan_history
ORDER  BY start_time;

-- 3. Wich resource group is a session in?
SELECT sid,
       resource_consumer_group
FROM   v$session;

-- 4. View privileges to Resource Group
SELECT grantee,
       granted_group
FROM   DBA_RSRC_CONSUMER_GROUP_PRIVS
ORDER  BY granted_group;

-- 5. Switched resource group
SELECT r.sid,
       c1.consumer_group original_consumer_group,
       c2.consumer_group current_consumer_group
FROM   v$rsrc_session_info r,
       dba_rsrc_consumer_groups c1,
       dba_rsrc_consumer_groups c2
WHERE  r.orig_consumer_group_id = c1.consumer_group_id
AND    r.current_consumer_group_id = c2.consumer_group_id
AND    r.orig_consumer_group_id <> r.current_consumer_group_id;

-- 6. View wait generated by resource groups
SELECT TO_CHAR(h.begin_time, 'HH:MI') begin_time,
       h.average_waiter_count,
       h.dbtime_in_wait,
       h.time_waited
FROM   v$waitclassmetric_history h,
       v$system_wait_class c
WHERE  h.wait_class_id = c.wait_class_id
AND    c.wait_class = ' SCHEDULER'
ORDER  BY h.begin_time;

-- 7. monitoring minute-by-minute
SELECT TO_CHAR(begin_time, 'HH:MI') begin_time,
       60 * (SELECT value FROM v$osstat WHERE stat_name = 'NUM_CPUS') total,
       60 * (SELECT value FROM v$parameter WHERE name = 'cpu_count') db_total,
       SUM(cpu_consumed_time) / 1000 consumed,
       SUM(cpu_wait_time) / 1000 throttled
FROM   gv$rsrcmgrmetric_history
GROUP  BY begin_time
ORDER  BY begin_time;

-- 8. Average Number of Sessions Throttled Per Minute
SELECT TO_CHAR(begin_time, 'HH:MI') begin_time,
       (SELECT value FROM v$osstat WHERE stat_name = 'NUM_CPUS') num_cpus,
       (SELECT value FROM v$parameter WHERE name = 'cpu_count') num_db_cpus,
       SUM(cpu_consumed_time) / 60000 avg_running,
       SUM(cpu_wait_time) / 60000 avg_throttled
FROM   v$rsrcmgrmetric_history
GROUP  BY begin_time
ORDER  BY begin_time;