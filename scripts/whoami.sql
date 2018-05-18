SET FEED OFF LINES 100

COL "Current Session Information" FOR A50
SELECT value "Current Session Information" FROM (
        (
                SELECT
                        'USER...........: '  || a.USERNAME "USERNAME",
                        'OS.USER:.......: '  || a.OSUSER ||' ('||c.SPID||')' "OSUSER",
                        'CURRENT_SCHEMA.: '  || a.CURRENT_SCHEMA "CURRENT_SCHEMA" ,
                        'SID_SERIAL:....: '  || a.SID||','||b.SERIAL# "SID",
                        'HOST CLIENT....: '  || a.HOST_CLIENT "HOST_CLIENT",
                        'LOGON TIME.....: '  || TO_CHAR(b.logon_time,'DD/MM/YY HH24:MI:SS') "LOGON",
                        'INSTANCE.......: (' || a.INSTANCE "INSTANCE",
                        'SYSDBA.........: '  || a.ISDBA "ISDBA",
                        'MODULE.........: '  || a.MODULE "MODULE",
                        'LANGUAGE.......: '  || a.LANGUAGE "LANGUAGE"
                FROM
                        (
                                SELECT
                                        SYS_CONTEXT ('USERENV', 'SESSION_USER')  "USERNAME",
                                        SYS_CONTEXT ('USERENV', 'CURRENT_SCHEMA') "CURRENT_SCHEMA",
                                        SYS_CONTEXT ('USERENV', 'OS_USER') "OSUSER",
                                        SYS_CONTEXT ('USERENV', 'SID')  "SID",
                                        SYS_CONTEXT ('USERENV', 'HOST') "HOST_CLIENT",
                                        SYS_CONTEXT ('USERENV', 'INSTANCE') || ') ' || SYS_CONTEXT ('USERENV', 'INSTANCE_NAME') "INSTANCE",
                                        SYS_CONTEXT ('USERENV', 'ISDBA') "ISDBA",
                                        SYS_CONTEXT ('USERENV', 'MODULE') "MODULE",
                                        SYS_CONTEXT ('USERENV', 'LANGUAGE') "LANGUAGE"
                                FROM dual
                        ) a,
                        V$SESSION b,
                        v$process c
                WHERE
                        a.sid=b.sid AND
                        b.paddr=c.addr
                        )
        )
UNPIVOT
(
        value FOR  value_type IN ("USERNAME","SID","CURRENT_SCHEMA","HOST_CLIENT","OSUSER","LOGON","INSTANCE","ISDBA","MODULE","LANGUAGE")
);

PROMPT
