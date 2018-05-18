select * from v$pwfile_users;

/*
Output:

USERNAME                       SYSDB SYSOP SYSAS
------------------------------ ----- ----- -----
SYS                            TRUE  TRUE  TRUE
ASMSNMP                        TRUE  FALSE FALSE
*/

create user user_123 identified by values 'PASSWORD_HASH';

/*
Output:

User created.
*/

select * from v$pwfile_users;

/*
Output:

USERNAME                       SYSDB SYSOP SYSAS
------------------------------ ----- ----- -----
SYS                            TRUE  TRUE  TRUE
ASMSNMP                        TRUE  FALSE FALSE
USER_123                       FALSE FALSE FALSE
*/

grant sysdba, sysoper to username;

/*
Output:

Grant succeeded.
*/

select * from v$pwfile_users;

/*
Output:

USERNAME                       SYSDB SYSOP SYSAS
------------------------------ ----- ----- -----
SYS                            TRUE  TRUE  TRUE
ASMSNMP                        TRUE  FALSE FALSE
USER_123                       TRUE  TRUE  FALSE
*/
