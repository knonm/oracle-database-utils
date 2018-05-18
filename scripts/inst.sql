SET LINESIZE 200
SET PAGESIZE 40
SET SERVEROUTPUT ON
SET ECHO OFF
SET FEED OFF

DECLARE

  vcDtIni    VARCHAR2(21);
  vcDtFormat CONSTANT VARCHAR2(21) := 'DD/MM/YYYY HH24:MI:SS';
  
BEGIN

  FOR lst IN (SELECT *
              FROM   gv$instance)
  LOOP
  
    vcDtIni := TO_CHAR(SYSDATE, vcDtFormat);
  
    dbms_output.put_line('------------ Instance and DB information ' || vcDtIni || ' ------------');
    dbms_output.put(CHR(10));
    dbms_output.put_line('Name.................: ' || '(' || lst.instance_number || ') ' || lst.instance_name);
    dbms_output.put_line('Hostname.............: ' || lst.host_name);
    dbms_output.put_line('Status...............: ' || lst.status);
    dbms_output.put_line('Up Time..............: ' || TO_CHAR(lst.startup_time, vcDtFormat));
    dbms_output.put_line('Logins...............: ' || lst.logins);
    
    FOR lst1 IN (SELECT * 
                 FROM   (SELECT status
                         FROM   v$session
                         WHERE  username IS NOT NULL) 
                 PIVOT  (COUNT(status)
                         FOR status IN
                         ('ACTIVE'   AS "ACT", 
                          'INACTIVE' AS "INA" ,
                          'KILLED'   AS "KIL",
                          'SNIPED'   AS "SNI")))
    LOOP
    
      dbms_output.put_line('Connections..........: ' || 'ACTIVE: '|| lst1.act || ' | INACTIVE: ' || lst1.ina || ' | KILLED: ' || lst1.kil || ' | SNIPED: ' || lst1.sni);
      
    END LOOP;
    
    dbms_output.put_line('Version..............: ' || lst.Version);
    
    FOR lst2 IN (SELECT * 
                 FROM   v$database)
    LOOP
    
      dbms_output.put_line('DBID and Name........: ' || '(' || lst2.dbid || ') - ' || lst2.name );
      dbms_output.put_line('Archive .............: ' || lst2.LOG_MODE);
      dbms_output.put_line('DB Role..............: ' || lst2.DATABASE_ROLE);
      dbms_output.put_line('DB Mode..............: ' || lst2.open_mode);
      dbms_output.put_line('DB Created...........: ' || TO_CHAR(lst2.created, vcDtFormat));
      dbms_output.put_line('Force Logging........: ' || lst2.FORCE_LOGGING);
      dbms_output.put_line('Current SCN..........: ' || lst2.CURRENT_SCN);
      dbms_output.put_line('Flashback............: ' || lst2.FLASHBACK_ON);
      dbms_output.put_line('DG Broker............: ' || lst2.DATAGUARD_BROKER);
      dbms_output.put_line('DG - Mode............: ' || lst2.PROTECTION_MODE);
      dbms_output.put(CHR(10));
      
    END LOOP;
    
    dbms_output.put_line('------------ Instance and DB information ' || vcDtIni || ' ------------');
    
  END LOOP;
END;
/