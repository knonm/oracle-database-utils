SET LINESIZE 300

SELECT u1.username,
       u2.password,
       u1.account_status,
       u1.lock_date,
       u1.expiry_date,
       u1.default_tablespace,
       u1.temporary_tablespace
FROM   dba_users u1,
       user$ u2
WHERE  u1.user_id = u2.user#
AND    UPPER(u.username) = UPPER(NVL('&pcUsername', u.username))
