-- APPEND: The APPEND hint instructs the optimizer to use direct-path INSERT with the subquery syntax of the INSERT statement.
-- The data blocks are not reorganized using APPEND, the new blocks are inserted after the water mark.

INSERT /*+ APPEND */
INTO   SCHEMA.TABLE_NAME
SELECT /*+ PARALLEL (A,4) */ *
FROM   SYS.AUD$ A;
