-- Create AWR report:
-- $ORACLE_HOME/rdbms/admin/awrrpt.sql
-- or
@?/rdbms/admin/awrrpt.sql

-- AWR config info
SELECT *
FROM   DBA_HIST_WR_CONTROL;

-- Change retention time of AWR and snapshot gathering interval
  -- retention: New retention time (in minutes)
  -- interval: New snapshot gathering interval (in minutes)
  -- topnsql: Specifying DEFAULT will revert the system back to the default behavior of Top 30 for statistics level TYPICAL and Top 100 for statistics level ALL
EXEC DBMS_WORKLOAD_REPOSITORY.MODIFY_SNAPSHOT_SETTINGS(interval => 60, retention => 43200, topnsql => 'DEFAULT');
