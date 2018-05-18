BEGIN
DBMS_SCHEDULER.CREATE_JOB (
   job_name             => 'sys.JOB_NAME',
   job_type             => 'PLSQL_BLOCK',
   job_action           => 'BEGIN PR_JOB; END;',
   start_date           => '01-JAN-16 03.24.00PM America/Sao_Paulo',
   repeat_interval      => 'FREQ=DAILY;INTERVAL=2',
   enabled              =>  TRUE,
   comments             => 'Teste job scheduler');
END;
/

BEGIN
DBMS_SCHEDULER.SET_ATTRIBUTE(name      => 'system.job_teste',
                             attribute => 'start_date',
                             value     => TO_DATE('2016-08-04 14:58:30', 'YYYY-MM-DD HH24:MI:SS'));
END;
/

BEGIN
DBMS_SCHEDULER.DROP_JOB(job_name => 'system.job_teste');
END;
/
