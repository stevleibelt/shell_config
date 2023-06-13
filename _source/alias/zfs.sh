#!/bin/bash
####
# Contains zfs dependend alias in alphabetically order
####
# @author stev leibelt <artodeto@bazzline.net>
# @since 2021-01-19
####

if [[ ${NET_BAZZLINE_ZFS_IS_AVAILABLE} -eq 1 ]]
then
    #c
    alias createZfsSnapshot=net_bazzline_create_zfs_snapshot

    #d
    alias deleteZfsSnapshot=net_bazzline_delete_zfs_snapshot
    alias deleteListOfDatedZfsSnapshots=net_bazzline_delete_list_of_dated_zfs_snapshots

    #l
    alias listZfsSnapshotDiskspace=net_bazzline_list_zfs_snapshot_diskspace
    alias listZfsSnapshots=net_bazzline_list_zfs_snapshots

    #s
    alias scrubListOfZfsPools=net_bazzline_scrub_list_of_zfs_pools
    alias sendAndReceiveZfs=net_bazzline_zfs_send_and_receive

    #w
    alias watchForZpoolStatus="net_bazzline_execute_as_super_user_when_not_beeing_root watch -n 60 'zpool status -v'"
fi
