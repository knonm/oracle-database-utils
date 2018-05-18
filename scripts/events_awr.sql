set lines 190
col event_name     for a30
col wait_class     for a20
col waits          for 999,999,999
col "TIME(s)"      for 999,999,999
col "AVG_WAIT(ms)" for 999,999,999

select snap_id,
       begin_time,
       end_time,
       (select i.instance_name
          from gv$instance i
         where i.INSTANCE_NUMBER = a.instance_number) as "INSTANCE",
       event_name,
       total_waits as "WAITS",
       event_time_waited as "TIME(s)",
       avg_wait as "AVG_WAIT(ms)",
       pct as "%PCT",
       wait_class
  from (select to_char(s.begin_interval_time, 'DD-MM-YYYY HH24:MI') as BEGIN_TIME,
               to_char(s.end_interval_time, 'DD-MM-YYYY HH24:MI') as END_TIME,
               m.*
          from (select ee.instance_number,
                       ee.snap_id,
                       ee.event_name,
                       round(ee.event_time_waited / 1000000) event_time_waited,
                       ee.total_waits,
                       round((ee.event_time_waited * 100) /
                             et.total_time_waited,
                             1) pct,
                       round((ee.event_time_waited / ee.total_waits) / 1000) avg_wait,
                       ee.wait_class
                  from (select ee1.instance_number,
                               ee1.snap_id,
                               ee1.event_name,
                               ee1.time_waited_micro - ee2.time_waited_micro event_time_waited,
                               ee1.total_waits - ee2.total_waits total_waits,
                               ee1.wait_class
                          from dba_hist_system_event ee1
                          join dba_hist_system_event ee2 on ee1.snap_id =
                                                            ee2.snap_id + 1
                                                        and ee1.instance_number =
                                                            ee2.instance_number
                                                        and ee1.event_id =
                                                            ee2.event_id
                                                        and ee1.wait_class_id <>
                                                            2723168908
                                                        and ee1.time_waited_micro -
                                                            ee2.time_waited_micro > 0
                        union
                        select st1.instance_number,
                               st1.snap_id,
                               st1.stat_name event_name,
                               st1.value - st2.value event_time_waited,
                               null total_waits,
                               null wait_class
                          from dba_hist_sys_time_model st1
                          join dba_hist_sys_time_model st2 on st1.instance_number =
                                                              st2.instance_number
                                                          and st1.snap_id =
                                                              st2.snap_id + 1
                                                          and st1.stat_id =
                                                              st2.stat_id
                                                          and st1.stat_name =
                                                              'DB CPU'
                                                          and st1.value -
                                                              st2.value > 0) ee
                  join (select et1.instance_number,
                              et1.snap_id,
                              et1.value - et2.value total_time_waited,
                              null wait_class
                         from dba_hist_sys_time_model et1
                         join dba_hist_sys_time_model et2 on et1.snap_id =
                                                             et2.snap_id + 1
                                                         and et1.instance_number =
                                                             et2.instance_number
                                                         and et1.stat_id =
                                                             et2.stat_id
                                                         and et1.stat_name =
                                                             'DB time'
                                                         and et1.value -
                                                             et2.value > 0) et on ee.instance_number =
                                                                                  et.instance_number
                                                                              and ee.snap_id =
                                                                                  et.snap_id) m
          join dba_hist_snapshot s on m.snap_id = s.snap_id
         where m.instance_number = 1
           and m.snap_id = 21019 --SNAP_ID
         order by PCT desc) a
where rownum <= 10
/
