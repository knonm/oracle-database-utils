# Listener configuration
# Listener default name: LISTENER

# Listener utility
lsnrctl

# Check listener status
lsnrctl status nome_do_listener

# Start listener
lsnrctl start nome_do_listener

# Stop listener
lsnrctl stop nome_do_listener

# Check if listener's log is enabled
lsnrctl status <LISTENER_NAME> | grep -i log

# Enable listener's log
lsnrctl set current_listener <LISTENER_NAME>
lsnrctl set log_status ON

# Disable listener's log
lsnrctl set current_listener <LISTENER_NAME>
lsnrctl set log_status OFF

# Disable listener's log from LISTENER.ORA
echo 'LOGGING_<LISTENER_NAME>=OFF' >> $ORACLE_HOME/network/admin/listener.ora
lsnrctl reload <LISTENER_NAME>

# Regex to seek errors on listener's log
# \* [0-9][0-9][0-9]*$
# \* [1-9]$

# Listener's log
lsnrctl set current_listener listener_name
lsnrctl set log_directory directory_name
lsnrctl set log_file file_name
lsnrctl set log_status [on|off]
