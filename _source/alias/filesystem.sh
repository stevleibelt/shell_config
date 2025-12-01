#!/bin/bash

#c
alias catLatestFile='cat "$(listLatestFile)"'
alias cdToCurrentUserGvfs='cd /run/user/${UID}/gvfs'
alias cdToLatestDirectory='cd $(listLatest)'
alias createSha512sumFromFile=net_bazzline_filesystem_create_sha512sum_from_file
alias cpLatestFile='net_bazzline_filesystem_copy_paste_latest_file'

#e
alias editLatestFile='$EDITOR "$(listLatestFile)"'  # either editLatestFile or openLatestFile wins
alias emptyTmp=net_bazzline_filesystem_generic_empty_tmp

#f
alias fixQuotes=net_bazzline_filesystem_generic_fix_quotes

#l
alias listBiggestSwapSpaceConsumers=net_bazzline_filesystem_list_biggest_swap_space_consumers
alias listBiggestDirectories=net_bazzline_filesystem_list_biggest_directories
alias listLatest="ls -t | head -n 1"
alias listLatestFile='net_bazzline_filesystem_list_latest_files 1'
alias lsGrep=net_bazzline_filesystem_ls_grep

#m
alias mvLatestFile='mv "$(listLatestFile)"'

#o
alias openLatestFile='$EDITOR "$(listLatestFile)"'  # either openLatestFile or editLatestFile wins

#w
alias watchForSync=net_bazzline_filesystem_watch_for_sync

