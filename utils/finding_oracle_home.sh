ps -ef | grep pmon

# Output:
ora1024   111111        1   0   Mar 23      -  0:12 ora_pmon_mysid
# ORACLE_SID is mysid

###

ls -l /proc/111111/cwd

# Output:
lr-x------   2 ora1024  dba  0 Mar 23 19:31 cwd -> /data/opt/app/product/10.2.0.4/db_1/dbs/
# ORACLE_HOME is /data/opt/app/product/10.2.0.4/db_1
