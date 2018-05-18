-- Explicitly force Oracle Database to begin writing to a new redo log file group, regardless of whether the files in the current redo log file group are full.
-- When you force a log switch, Oracle Database begins to perform a checkpoint but returns control to you immediately rather than when the checkpoint is complete.
ALTER SYSTEM SWITCH LOGFILE;

-- Explicitly force Oracle Database to perform a checkpoint, ensuring that all changes made by committed transactions are written to data files on disk.
-- Oracle Database does not return control to you until the checkpoint is complete.
ALTER SYSTEM CHECKPOINT;
