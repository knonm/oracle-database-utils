--To start trace:
EXEC dbms_support.start_trace_in_session (<SID>, <Serial#>);
EXEC dbms_support.start_trace_in_session (<SID>, <Serial#>, waits => TRUE, binds=> TRUE);

--To stop trace:
EXEC dbms_support.stop_trace_in_session (<SID>, <Serial#>);

--To enable event 10046 level 8 in a session with SID 9 and serial number 29 use
EXECUTE dbms_system.set_ev (<SID>,<Serial#>,10046,8,'');

--To disable event 10046 in the same session use
EXECUTE dbms_system.set_ev (<SID>,<Serial#>,10046,0,'');


-- All versions.
ALTER SESSION SET sql_trace=TRUE;
ALTER SESSION SET sql_trace=FALSE;

EXEC DBMS_SESSION.set_sql_trace(sql_trace => TRUE);
EXEC DBMS_SESSION.set_sql_trace(sql_trace => FALSE);

ALTER SESSION SET EVENTS '10046 trace name context forever, level 8';
ALTER SESSION SET EVENTS '10046 trace name context off';

EXEC DBMS_SYSTEM.set_sql_trace_in_session(sid=>123, serial#=>1234, sql_trace=>TRUE);
EXEC DBMS_SYSTEM.set_sql_trace_in_session(sid=>123, serial#=>1234, sql_trace=>FALSE);

EXEC DBMS_SYSTEM.set_ev(si=>123, se=>1234, ev=>10046, le=>8, nm=>' ');
EXEC DBMS_SYSTEM.set_ev(si=>123, se=>1234, ev=>10046, le=>0, nm=>' ');

-- Available from SQL*Plus since 8i (commandline utility prior to this.
CONN sys/password AS SYSDBA;  -- User must have SYSDBA.
ORADEBUG SETMYPID;            -- Debug current session.
ORADEBUG SETOSPID 1234;       -- Debug session with the specified OS process.
ORADEBUG SETORAPID 123456;    -- Debug session with the specified Oracle process ID.

ORADEBUG EVENT 10046 TRACE NAME CONTEXT FOREVER, LEVEL 12;
ORADEBUG TRACEFILE_NAME;      -- Display the current trace file.
ORADEBUG EVENT 10046 TRACE NAME CONTEXT OFF;

-- All versions, requires DBMS_SUPPORT package to be loaded.
EXEC DBMS_SUPPORT.start_trace(waits=>TRUE, binds=>true);
EXEC DBMS_SUPPORT.stop_trace;

EXEC DBMS_SUPPORT.start_trace_in_session(sid=>123, serial=>1234, waits=>TRUE, binds=>FALSE);
EXEC DBMS_SUPPORT.stop_trace_in_session(sid=>123, serial=>1234);


-- Oracle 10g
EXEC DBMS_MONITOR.session_trace_enable;
EXEC DBMS_MONITOR.session_trace_enable(waits=>TRUE, binds=>FALSE);
EXEC DBMS_MONITOR.session_trace_disable;

EXEC DBMS_MONITOR.session_trace_enable(session_id=>530, serial_num=>2853);
EXEC DBMS_MONITOR.session_trace_enable(session_id =>1234, serial_num=>1234, waits=>TRUE, binds=>FALSE);
EXEC DBMS_MONITOR.session_trace_disable(session_id=>1234, serial_num=>1234);

EXEC DBMS_MONITOR.client_id_trace_enable(client_id=>'cid');
EXEC DBMS_MONITOR.client_id_trace_enable(client_id=>'cid', waits=>TRUE, binds=>FALSE);
EXEC DBMS_MONITOR.client_id_trace_disable(client_id=>'cid');

EXEC DBMS_MONITOR.serv_mod_act_trace_enable(service_name=>'sname', module_name=>'test_api', action_name=>'running');
EXEC DBMS_MONITOR.serv_mod_act_trace_enable(service_name=>'sname', module_name=>'test_api', action_name=>'running', waits=>TRUE, binds=>FALSE);
EXEC DBMS_MONITOR.serv_mod_act_trace_disable(service_name=>'sname', module_name=>'test_api', action_name=>'running');
