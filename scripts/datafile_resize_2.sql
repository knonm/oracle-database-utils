select /*+rule*/ 'alter database datafile '''|| rf.F_NAME ||''' resize '||
       ceil (rf.F_MIN_MB + rf.F_INC_MB - mod (rf.F_MIN_MB, rf.F_INC_MB)) ||
       'M /* used:'|| rf.F_MIN_MB ||'/max:'|| rf.F_MAX_MB ||'M */ ; ' RESIZE_TO_MINIMUM
from (select f.F_NAME, f.F_INC_MB, f.F_MAX_MB,
             least (f.F_MAX_MB, greatest (50, f.F_INC_MB, f.F_HWM_MB)) F_MIN_MB
      from (select ff.tablespace_name F_TBS, ff.file_name F_NAME,
                   ceil (greatest (max (ff.increment_by) * tt.BLOCK_SIZE / 1024 / 1024, 50)) F_INC_MB,
                   ceil (greatest (max (ff.maxbytes), max (ff.bytes), 52428800) / 1024 / 1024) F_MAX_MB,
                   ceil (greatest (max (nvl (ee.block_id, 0) + nvl (ee.blocks, 0)) * tt.BLOCK_SIZE / 1024 / 1024, 50)) F_HWM_MB
            from dba_data_files ff, dba_extents ee, dba_tablespaces tt
            where ff.tablespace_name = ee.tablespace_name(+)
            and ff.file_id = ee.file_id(+)
            and ff.tablespace_name = tt.tablespace_name(+)
            group by ff.tablespace_name, ff.file_name, tt.block_size) f
     ) rf
order by rf.f_name;
