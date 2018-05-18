/*
REBALANCE:
Use this clause to manually rebalance the disk group. Oracle ASM redistributes data files evenly across all drives.
This clause is rarely necessary, because Oracle ASM allocates files evenly and automatically rebalances disk groups when the storage configuration changes.
However, it is useful if you want to use the POWER clause to control the speed of what would otherwise be an automatic rebalance operation.

POWER:
In the POWER clause, specify a value from 0 to 11, where 0 stops the rebalance operation and 11 permits Oracle ASM to execute the rebalance as fast as possible.
The value you specify in the POWER clause defaults to the value of the ASM_POWER_LIMIT initialization parameter.
If you omit the POWER clause, then Oracle ASM executes both automatic and specified rebalance operations at the power determined by the value of the ASM_POWER_LIMIT initialization parameter.

WAIT:
Specify WAIT to allow a script that adds or removes disks to wait for the disk group to be rebalanced before returning control to the user.
You can explicitly terminate a rebalance operation running in WAIT mode, although doing so does not undo any completed disk add or drop operation in the same statement.

NOWAIT:
Specify NOWAIT if you want control returned to the user immediately after the statement is issued. This is the default.

You can monitor the progress of the rebalance operation by querying the V$ASM_OPERATION dynamic performance view.
*/

ALTER DISKGROUP DGNAME ADD DISK '/dev/disk_1','/dev/disk_2' REBALANCE POWER 3 NO WAIT;
