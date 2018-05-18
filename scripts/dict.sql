SET LINESIZE 300
SET VERIFY OFF

COLUMN comments FORMAT A80

ACCEPT pcTableName PROMPT 'Table/view name: '

SELECT *
FROM   dict
WHERE  UPPER(table_name) LIKE UPPER('%&pcTableName%');
