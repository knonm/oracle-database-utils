col opname for a30
col message for a30 wra on
col units for a15
set lin 300 pages 1000 feed off echo off
SET ECHO OFF

alter session set nls_date_format='dd-mm-yyyy hh24:mi:ss';

select OPNAME,
--message,
SOFAR,TOTALWORK,round((SOFAR*100/decode(TOTALWORK,0,SOFAR,TOTALWORK)),2) PCT_DONE,
--UNITS,
round(elapsed_seconds/60,1) ela_min,round(time_remaining/60,1) eta_min,
START_TIME,round(time_remaining/60,1)/60/24+sysdate finish_time
from v$session_longops
where
OPNAME like 'RMAN%'
and SOFAR != TOTALWORK
order by 8;

SELECT
  'DUPLICATE/RESTORE THROUGHPUT',
  round(SUM(v.value/1024/1024),1) mbytes_sofar,
  round(SUM(v.value     /1024/1024)/nvl((SELECT MIN(elapsed_seconds)
  FROM v$session_longops
  WHERE OPNAME LIKE 'RMAN: aggregate input'
  AND SOFAR            != TOTALWORK
  AND elapsed_seconds IS NOT NULL
  ),SUM(v.value     /1024/1024)),2) mbytes_per_sec,
  n.name
FROM gv$sesstat v,
  v$statname n,
  gv$session s
WHERE v.statistic#=n.statistic#
AND n.name = 'physical write total bytes'
AND v.sid = s.sid
AND v.inst_id=s.inst_id
AND s.program like 'rman@%'
GROUP BY 'DUPLICATE/RESTORE THROUGHPUT',n.name;

SELECT
  'BACKUP THROUGHPUT',
  round(SUM(v.value/1024/1024),1) mbytes_sofar,
  round(SUM(v.value     /1024/1024)/nvl((SELECT MIN(elapsed_seconds)
  FROM v$session_longops
  WHERE OPNAME LIKE 'RMAN: aggregate output'
  AND SOFAR            != TOTALWORK
  AND elapsed_seconds IS NOT NULL
  ),SUM(v.value     /1024/1024)),2) mbytes_per_sec,
  n.name
FROM gv$sesstat v,
  v$statname n,
  gv$session s
WHERE v.statistic#=n.statistic#
AND n.name = 'physical read total bytes'
AND v.sid = s.sid
AND v.inst_id=s.inst_id
AND s.program like 'rman@%'
GROUP BY 'BACKUP THROUGHPUT',n.name;
