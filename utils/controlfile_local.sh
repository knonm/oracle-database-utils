### From filesystem to ASM:

# SQL> ALTER SYSTEM SET control_files='+DG_NAME','+DG_NAME' SCOPE=SPFILE;

rman target /

# RMAN> SHUTDOWN IMMEDIATE

# RMAN> STARTUP NOMOUNT

# RMAN> RESTORE CONTROLFILE FROM '/path/control.ora';

# RMAN> ALTER DATABASE MOUNT;

# RMAN> ALTER DATABASE OPEN;

# RMAN> EXIT

# SQL> SELECT * FROM v$controlfile;


### ### ###


### From filesystem to filesystem:

cp "/path_old/control_old.ora" "/path_new/control_new_1.ora"

cp "/path_old/control_old.ora" "/path_new/control_new_2.ora"

# SQL> ALTER SYSTEM SET control_files='/path_new/control_new_1.ora','/path_new/control_new_2.ora' SCOPE=SPFILE;

# SQL> SHUTDOWN IMMEDIATE

# SQL> STARTUP

# SQL> SELECT * FROM v$controlfile;
