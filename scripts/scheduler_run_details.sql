SET LINESIZE 500

SELECT owner, job_name, status, log_date, run_duration, additional_info
FROM   dba_scheduler_job_run_details
WHERE  owner = 'SYS'
AND    job_name = 'JOB_REBUILD_UNUSABLE'
ORDER  BY log_date ASC;
