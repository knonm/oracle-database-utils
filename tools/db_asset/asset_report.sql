-- Query for gathering info from OEM's views/tables and create a report for asset purposes.

SET LINESIZE 300
SET PAGESIZE 100

COLUMN instance         FORMAT A10
COLUMN hostname         FORMAT A10
COLUMN vip_host         FORMAT A10
COLUMN core             FORMAT 999
COLUMN ram              FORMAT 999999999
COLUMN storage          FORMAT A10
COLUMN dgname           FORMAT A10
COLUMN ip               FORMAT A15
COLUMN port             FORMAT A4
COLUMN os               FORMAT A10
COLUMN version          FORMAT A15
COLUMN psu              FORMAT A10
COLUMN environment      FORMAT A15
COLUMN log_mode         FORMAT A10
COLUMN instance_status  FORMAT A10
COLUMN disabled_in      FORMAT A10
COLUMN obs              FORMAT A10
COLUMN last_modified    FORMAT A10

SELECT t.instance_name                    AS "Instance Name",
       NVL(t.database_name, ta.instancia) AS "Database Name",
       NVL(ta.hostname, t.hostname)       AS "Host",
       ta.vip_host                        AS "VIP Host",
       t.ip                               AS "IP",
       t.porta                            AS "Port",
       t.storage                          AS "Storage Type",
       t.dgname                           AS "DGs",
       t.version                          AS "Version",
       ta.psu                             AS "PSU",
       ta.environment_type                AS "Environment",
       t.log_mode                         AS "Log Mode",
       t.dataguard_status                 AS "Dataguard Status",
       t.core                             AS "CPU Cores",
       t.ram                              AS "RAM (MB)",
       t.os                               AS "OS",
       ta.instance_status                 AS "Status",
       ta.contingency_host                AS "Contingency Host",
       ta.dr_host                         AS "DR",
       ta.contingency_type                AS "Contingency Type",
       ta.disabled_in                     AS "Disabled In",
       ta.comments                        AS "Comments"
       ta.last_modified                   AS "Last Modified"
FROM   (SELECT UPPER(TRIM(instance_name)) instance_name,
               UPPER(TRIM(database_name)) database_name,
               REPLACE(UPPER(TRIM(hostname)), '.domain', '') hostname,
               core,
               ram,
               os,
               REPLACE(storage, '+ASM', 'ASM') storage,
               version,
               log_mode,
               dataguard_status,
               port,
               ip,
               SUBSTR(SYS_CONNECT_BY_PATH(key_value , ', '), 3) dgname
        FROM   (SELECT instance_name,
                       database_name,
                       hostname,
                       core,
                       ram,
                       os,
                       storage,
                       version,
                       log_mode,
                       dataguard_status,
                       port,
                       ip,
                       masm.key_value key_value,
                       ROW_NUMBER() OVER (PARTITION BY a.database_name, a.hostname ORDER BY masm.key_value) AS curr,
                       ROW_NUMBER() OVER (PARTITION BY a.database_name, a.hostname ORDER BY masm.key_value) - 1 AS prev
                FROM   (SELECT *
                        FROM   (SELECT ta.source_target_name AS target_name,
                                       ta.source_target_type AS target_type,
                                       os.host_name AS hostname,
                                       DECODE(UPPER(TRIM(os.ma)), 'POWERPC', os.physical_cpu_count, os.logical_cpu_count) AS core,
                                       os.mem AS ram,
                                       os.os_summary AS os,
                                       tp.property_name,
                                       DECODE(tp.property_name, 'OSMInstance',
                                              NVL(TRIM(tp.property_value), 'FS'),
                                              tp.property_value) AS property_value
                                FROM   mgmt$target_associations ta,
                                       mgmt$target_properties tp,
                                       mgmt$os_hw_summary os
                                WHERE  ((tp.target_name = ta.source_target_name
                                AND      tp.target_type = ta.source_target_type) OR
                                        (tp.target_name = ta.assoc_target_name
                                AND      tp.target_type = ta.assoc_target_type))
                                AND    os.target_name = ta.assoc_target_name
                                AND    os.target_type = ta.assoc_target_type
                                AND    ta.assoc_target_type = 'host'
                                AND    ta.source_target_type = 'oracle_database'
                                AND    tp.property_name IN ('DBName', 'DBVersion', 'DataGuardStatus', 'InstanceName', 'IP_address', 'log_archive_mode', 'OSMInstance', 'Port'))
                        PIVOT
                        (
                        MIN(property_value)
                        FOR property_name IN ('DBName' AS database_name, 'DataGuardStatus' AS dataguard_status, 'InstanceName' AS instance_name, 'OSMInstance' AS storage, 'DBVersion' AS version, 'log_archive_mode' AS log_mode, 'Port' AS port, 'IP_address' AS ip)
                        )) a,
                       (SELECT DISTINCT target_name, target_type, key_value
                        FROM   mgmt$metric_current
                        WHERE  target_type = 'osm_instance'
                        AND    (metric_column IN ('rebalInProgress','free_mb','usable_file_mb','type','computedImbalance','usable_total_mb','percent_used','safe_percent_used','diskCnt')
                                OR (metric_column = 'total_mb' AND metric_name = 'DiskGroup_Usage'))) masm,
                       (SELECT source_target_name,
                               source_target_type,
                               assoc_target_name,
                               assoc_target_type
                        FROM   mgmt$target_associations
                        WHERE  assoc_target_type = 'osm_instance') tasm
                WHERE  a.target_name = tasm.source_target_name (+)
                AND    a.target_type = tasm.source_target_type (+)
                AND    masm.target_name (+) = tasm.assoc_target_name
                AND    masm.target_type (+) = tasm.assoc_target_type)
        WHERE CONNECT_BY_ISLEAF = 1
        CONNECT BY prev = PRIOR curr AND database_name = PRIOR database_name AND hostname = PRIOR hostname
        START WITH curr = 1) t
FULL   OUTER JOIN schema1.tb_asset ta
ON     t.database_name = ta.instance_name
AND    t.hostname      = ta.hostname;
