COLUMN LOCKS FORMAT A25
COLUMN line  FORMAT A80

WITH
  lock1 AS (  -- Search blockers and waiters
    SELECT a.sid blocker,a.inst_id blocker_inst, b.sid waiter, b.inst_id waiter_inst, a.type,
           DECODE(a.type,
                  'TM', DECODE(o.object_name,
                               NULL, TO_CHAR(a.id1),
                               o.owner||'.'||o.object_name||
                                 DECODE(o.subobject_name,
                                        NULL, '',
                                        '.'||o.subobject_name))
                  ) object
    FROM gv$lock a, gv$lock b, dba_objects o
    WHERE a.block = 1
      AND b.request > 0
      AND b.id1 = a.id1
      AND b.id2 = a.id2
      AND b.type = a.type
      AND a.type IN ('TX','TM')
      AND o.object_id (+) = a.id1
  ),
  lock2 AS ( -- Search associated TM lock and object
    SELECT
                TO_CHAR(l.blocker) blocker,
                l.blocker_inst,
                l.waiter  waiter,
                l.waiter_inst,
        DECODE( l.type,
                                'TM', l.object,
                                o.owner||'.'||o.object_name||
                DECODE(o.subobject_name,
                        NULL, '',
                        '.'||o.subobject_name)
                 ) object,
                                        s.serial#,
                s.seconds_in_wait sec,
                s.event,
                s.sql_id,
                s.username
    FROM lock1 l, gv$lock c, gv$session s, dba_objects o
    WHERE c.sid (+) = l.waiter
      AND c.type (+) = 'TM'
      AND s.row_wait_obj# (+) = c.id1
      AND s.sid (+) = c.sid
      AND o.object_id (+) = s.row_wait_obj#
      AND ( l.type = 'TM'              -- Previous row already a TM
          OR c.sid IS NULL             -- No TM found
          or o.object_name IS NOT NULL -- if TM then object in v$session
          )
    ORDER BY 1, 2
  ),
  top_blockers AS (
    SELECT DISTINCT l.blocker
    FROM lock1 l
    WHERE blocker NOT IN (SELECT waiter FROM lock2)
  )
-- Now build hierarchy
SELECT
        LPAD(' ',3*(LEVEL-1))||l.blocker||'('||l.blocker_inst||')'||' <-- '||l.waiter||'('||l.waiter_inst||')' "LOCKS",
        l.object,
        l.event,
        l.username "Username WAITER",
        l.sql_id,
        TO_CHAR(TRUNC(sec/3600),'FM9900') || ':' ||
    TO_CHAR(TRUNC(MOD(sec,3600)/60),'FM00') || ':' ||
    TO_CHAR(MOD(sec,60),'FM00') Time
FROM lock2 l
CONNECT BY PRIOR waiter = blocker
START WITH blocker IN (SELECT blocker FROM top_blockers)
/