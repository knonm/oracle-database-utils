SET LINESIZE 300
SET PAGESIZE 0
SET HEADING OFF
SET FEEDBACK OFF
SET TRIMSPOOL ON
SET VERIFY OFF
SET ECHO OFF

COLUMN A FORMAT A300

SELECT 'UPDATE schema1.tb_asset SET psu = ''' || VERSION || ''', last_modified = SYSDATE WHERE UPPER(instance_name) = ''' || INST || ''';'
FROM (
  SELECT
    (SELECT UPPER(host_name) FROM v$instance) HOSTN,
    (SELECT UPPER(instance_name) FROM v$instance) INST,
    (SELECT VERSION
     FROM   (SELECT (SELECT  vers
                     FROM    (SELECT TO_CHAR(rh2.id) vers
                              FROM   dba_registry_history rh2
                              WHERE  rh2.action_time =
                                     (SELECT MAX(rh3.action_time)
                                      FROM   dba_registry_history rh3
                                      WHERE  rh3.comments LIKE '%PSU%'
                                      AND    NVL(SUBSTR(rh3.version, 1, INSTR(rh3.version, '.', 1, 4)-1), rh3.version) =
                                             (SELECT NVL(SUBSTR(version, 1, INSTR(version, '.', 1, 4)-1), version) FROM v$instance))
                              UNION ALL
                              SELECT '0' vers FROM dual)
                       WHERE ROWNUM = 1) AS VERSAO
               FROM   dba_registry_history rh
               WHERE  rh.action_time =
                      (SELECT MAX(action_time)
                       FROM   dba_registry_history
                       WHERE  version IS NOT NULL)
               UNION ALL
               SELECT '0'
               FROM   v$instance)
       WHERE  ROWNUM = 1) VERSION
       FROM dual) A;
