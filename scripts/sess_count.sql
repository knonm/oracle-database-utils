SELECT username,
       status,
       COUNT(*) cnt
FROM   v$session
GROUP  BY username, status
ORDER  BY 1, 2;
