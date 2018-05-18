# SPFILE and/or PFILE location: $ORACLE_HOME/dbs
  # Order:
    # 1. SPFILE: spfile<ORACLE_SID>.ora
	  # 2. PFILE: init<ORACLE_SID>.ora
    # 3. Default: init.ora

# sqlnet.ora -> update NAMES.DIRECTORY_PATH to "EZCONNECT"
# Example: NAMES.DIRECTORY_PATH=(TNSNAMES,LDAP,ONAMES,EZCONNECT)
sqlplus system@\"hostnameserver:1111/instancename\"

# OPatch
./opatch lsinventory

###
### Set default sqlplus editor ###
###

# Change file
vi $ORACLE_HOME/sqlplus/admin/glogin.sql

# Set default editor
DEFINE _EDITOR = vi

###
### Set default sqlplus editor ###
###

# Show ORA errors description
oerr ora 00600

# tkprof - Format trace file (.trc)
tkprof /u01/app/oracle/diag/rdbms/sid/SID/trace/SID_ora_11111.trc /u01/app/oracle/diag/rdbms/sid/SID/trace/SID_ora_11111.tkp
