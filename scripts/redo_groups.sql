SET LINESIZE 300

/*
 * Display logfile information from the control file.
 *
 * Status description:
 *   Current: Current Redo Group, where the redo information is being written now.
 *   Active: After archive creation and before checkpoint (unload buffer cache on datafile).
 *   Inactive: Status after "Active" and before "Current".
 *
 * Current ---[Gera archive]---> Active ---[Faz checkpoint]---> Inactive
 *   ^                                                             |
 *   |_____________________________________________________________|
 *
 */
SELECT group#,
       members,
       status
FROM   v$log;
