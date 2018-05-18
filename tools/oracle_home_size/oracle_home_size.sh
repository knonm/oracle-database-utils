#!/bin/ksh

# Check Oracle Home size from servers listed in "servers.txt".
# Also checks if /u01 filesystem exists, and if so, list it's size.

OUTFILE=oracle_home_size.csv

echo HOSTNAME\;INSTANCE\;ORACLE_HOME\;ORA_HOME_SIZE\;FS_U01_SIZE 1>${OUTFILE}

for srv in $(cat servers.txt)
do
  ssh -q $srv "
    if [[ ! -f /var/opt/oracle/oratab ]]
    then
      ORATABDIR=/etc/oratab
    else
      ORATABDIR=/var/opt/oracle/oratab
    fi

    for ORA_TAB in \$(sed '/^#/d;/^*/d;/^$/d' \${ORATABDIR} | awk '{print \$1}')
    do

      ORA_HOME=\$(echo \$ORA_TAB | awk -F: '{print \$2}')
      ORA_INST=\$(echo \$ORA_TAB | awk -F: '{print \$1}')

      if [[ \$(uname) == 'AIX' ]]
      then

        ORA_HOME_SIZE=\$(echo \$(df -g \$ORA_HOME | grep -v '^Filesystem') | awk '{ print \$2 \";\" \$4 \";\" \$7}')
        FS_U01_SIZE=\$(echo \$(df -g | grep -v '^Filesystem' | grep -i /u01) | awk '{ print \$2 \";\" \$4 \";\" \$7}')

      elif [[ \$(uname) == 'SunOS' ]]
      then

        ORA_HOME_SIZE=\$(echo \$(df -h \$ORA_HOME | grep -v '^Filesystem') | awk '{ print \$2 \";\" \$5 \";\" \$6}')
        FS_U01_SIZE=\$(echo \$(df -h | grep -v '^Filesystem' | grep -i /u01) | awk '{ print \$2 \";\" \$4 \";\" \$7}')

      else

        ORA_HOME_SIZE=\$(echo \$(df -h \$ORA_HOME | grep -v '^Filesystem') | awk '{ print \$2 \";\" \$5 \";\" \$6}')
        FS_U01_SIZE=\$(echo \$(df -h | grep -v '^Filesystem' | grep -i /u01) | awk '{ print \$2 \";\" \$4 \";\" \$7}')

      fi

      echo \$(hostname)\;\$ORA_INST\;\$ORA_HOME\;\$ORA_HOME_SIZE\;\$FS_U01_SIZE

    done

    exit
" 1>>${OUTFILE}
done
