/*
NORMAL REDUNDANCY:
Two-way mirroring, requiring two failure groups.

HIGH REDUNDANCY:
Three-way mirroring, requiring three failure groups.

EXTERNAL REDUNDANCY:
No mirroring for disks that are already protected using hardware mirroring or RAID.

REGULAR (default):
Regular disks, or disks in non-quorum failure groups, can contain any files.

QUORUM:
Quorum disks, or disks in quorum failure groups, cannot contain any database files, the Oracle Cluster Registry (OCR), or dynamic volumes.
However, QUORUM disks can contain the voting file for Cluster Synchronization Services (CSS). Oracle ASM uses quorum disks or disks in quorum failure groups for voting files whenever possible.
Disks in quorum failure groups are not considered when determining redundancy requirements.

Specify either QUORUM or REGULAR before the keyword FAILGROUP if you are explicitly specifying the failure group.
If you are creating a disk group with implicitly created failure groups, then specify these keywords before the keyword DISK.

FAILGROUP:
Use this clause to specify a name for one or more failure groups.
If you omit this clause, and you have specified NORMAL or HIGH REDUNDANCY, then Oracle Database automatically adds each disk in the disk group to its own failure group.
The implicit name of the failure group is the same as the operating system independent disk name (see "NAME Clause").
You cannot specify this clause if you are creating an EXTERNAL REDUNDANCY disk group.
*/

CREATE DISKGROUP 'diskgroupname' NORMAL REDUNDANCY REGULAR FAILGROUP 'failgroupname' DISK '';
