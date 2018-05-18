COLUMN additional_info FORMAT A60

SELECT jl.owner,
       jl.job_name,
       jl.status,
       MAX(jl.log_date) AS log_date,
       SUBSTR(TO_CHAR(jl.additional_info), 1, 20) AS info
FROM   dba_scheduler_job_log jl
JOIN   dba_scheduler_jobs j
ON     j.owner = jl.owner
AND    j.job_name = jl.job_name
GROUP  BY jl.owner,
          jl.job_name,
          jl.status,
          SUBSTR(TO_CHAR(jl.additional_info), 1, 20);
