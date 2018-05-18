# Using datapump to generate DDL
cat <<EOF > ddl.txt
-------------------
directory=DUMPFILE_DIR
logfile=ddl.log
dumpfile=dumpfile_%U.dmp
transform=OID:n,SEGMENT_ATTRIBUTES:n,STORAGE:n
full=y
sqlfile=ddl.sql
-----------
EOF

impdp system/password parfile=ddl.txt

###

# Generate DDL from dump

# Generating DDL to text file (Windows):
  # C:\>imp scott/tiger  file=c:\scott indexfile=c:\ddl.sql
