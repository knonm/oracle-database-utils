SET LINESIZE 300
SET PAGESIZE 100
SET ECHO OFF
SET FEEDBACK OFF

COLUMN owner HEADING "Owner"
COLUMN state HEADING "State"
COLUMN job_name HEADING "Job Name"
COLUMN job_action HEADING "Job Action" FORMAT A40
COLUMN repeat_interval HEADING "Repeat Interval" FORMAT A40
COLUMN enabled HEADING "Enabled" FORMAT A10
COLUMN last_run_duration HEADING "Last Run Duration" FORMAT A30
COLUMN next_run_date HEADING "Next Run Date"

SELECT owner,
       state,
       job_name,
       job_action,
       repeat_interval,
       enabled,
       last_run_duration,
       TO_CHAR(next_run_date, 'DD/MM/YY HH24:MI:SS') AS next_run_date
FROM   dba_scheduler_jobs
ORDER  BY state;
