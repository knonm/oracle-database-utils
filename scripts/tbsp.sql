SELECT 1 seq,
       b.tablespace_name,
       nvl(x.fs,0)/y.ap*100 pf,
       b.file_name file_name,
       b.bytes/&&b_div total_byt,
       NVL((b.bytes-SUM(f.bytes))/&&b_div,b.bytes/&&b_div) used_byt,
       NVL(SUM(f.bytes)/&&b_div,0) free_byt,
       NVL(SUM(f.bytes)/b.bytes*100,0) pct_free
FROM   dba_free_space f,
       dba_data_files b,
       (SELECT y.tablespace_name,
               SUM(y.bytes) fs
        FROM   dba_free_space y
        GROUP  BY y.tablespace_name) x,
       (SELECT x.tablespace_name,
               SUM(x.bytes) ap
        FROM   dba_data_files x
        GROUP  BY x.tablespace_name) y
WHERE  f.file_id(+) = b.file_id
AND    f.tablespace_name(+) = b.tablespace_name
AND    x.tablespace_name(+) = y.tablespace_name
AND    y.tablespace_name = b.tablespace_name
GROUP  BY b.tablespace_name, nvl(x.fs,0)/y.ap*100, b.file_name, b.bytes
UNION
SELECT 2 seq,
       tablespace_name,
       j.bf/k.bb*100 pf,
       b.name file_name,
       b.bytes/&&b_div total_byt,
       a.bytes_used/&&b_div used_byt,
       a.bytes_free/&&b_div free_byt,
       a.bytes_free/b.bytes*100 pct_free
FROM   v$temp_space_header a,
       v$tempfile b,
       (SELECT SUM(bytes_free) bf
        FROM   v$temp_space_header) j,
       (SELECT SUM(bytes) bb
        FROM   v$tempfile) k
WHERE  a.file_id = b.file#
ORDER  BY 1,2,4,3;
