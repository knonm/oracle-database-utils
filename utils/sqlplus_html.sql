-- sqlplus -S -M "HTML ON TABLE 'BORDER="2"'" system/${PASS}@${INST} @script.sql > ${ARQ2}.html 
SET PAGES 50000
SET LINES 9999
Set sqlblanklines on
SET FEEDBACK OFF
SET MARKUP HTML ON ENTMAP ON PREFORMAT OFF
spool consulta_dba_data_files.xls
select * from dba_data_files;
SPOOL OFF
SET MARKUP HTML OFF ENTMAP OFF PREFORMAT ON
SET FEEDBACK ON
SET TERM ON
