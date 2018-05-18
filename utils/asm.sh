# File copy via ASM
# cp <FILE_NAME> <ORACLE_SCHEMA>@<HOSTNAME>.<SID>:<PATH_ASM>
asmcmd cp dump_file.dmp sys@HOSTNAME_1.+ASM:+DGNAME/FOLDER_NAME/dump_file.dmp

# List diskgroups
asmcmd lsdg

# List disks
asmcmd lsdsk

# List candidate disks
asmcmd lsdsk --candidate
