set pagesize 5555
column dummy noprint
column  pct_used          format 999.9       heading "%|Used"
column  name              format a20         heading "Tablespace Name"
column  mbytes            format 999,999,999 heading "MBytes"
column  used              format 999,999,999 heading "Used"
column  free              format 999,999,999 heading "Free"
column  mbytes_largest    format 999,999,999 heading "Largest"
col file_name for a60
break   on report
compute sum of mbytes on report
compute sum of free on report
compute sum of used on report

select nvl(b.tablespace_name, nvl(a.tablespace_name,'UNKOWN')) name,
       mbytes_alloc mbytes, mbytes_alloc-nvl(mbytes_free,0) used,
       nvl(mbytes_free,0) free, ((mbytes_alloc-nvl(mbytes_free,0))/mbytes_alloc)*100 pct_used,
       nvl(mbytes_largest,0) largest
from ( select sum(bytes)/1024/1024 mbytes_free,
              round(max(bytes)/1024/1024,2) mbytes_largest,
              tablespace_name
       from  sys.dba_free_space
       group by tablespace_name ) a,
     ( select sum(bytes)/1024/1024 mbytes_alloc,
              tablespace_name
       from sys.dba_data_files
       group by tablespace_name )b
where a.tablespace_name (+) = b.tablespace_name
--and a.tablespace_name='TBSP_NAME'
order by 5 desc;
