#!/bin/bash

#c
alias catLatestFile='cat $(listLatest)'
alias cdToCurrentUserGvfs='cd /run/user/${UID}/gvfs'
alias cdToLatestDirectory='cd $(listLatest)'
alias createSha512sumFromFile=net_bazzline_filesystem_create_sha512sum_from_file

#e
alias editLatestFile='$EDITOR $(listLatest)'  # either editLatestFile or openLatestFile wins
alias emptyTmp=net_bazzline_filesystem_generic_empty_tmp

#f
alias fixQuotes=net_bazzline_filesystem_generic_fix_quotes

#l
alias listBiggestSwapSpaceConsumers=net_bazzline_filesystem_list_biggest_swap_space_consumers
alias listBiggestDirectories=net_bazzline_filesystem_list_biggest_directories
alias listLatest="ls -t | head -n 1"
alias lsGrep=net_bazzline_filesystem_ls_grep

#o
alias openLatestFile='$EDITOR $(listLatest)'  # either openLatestFile or editLatestFile wins

#w
alias watchForSync=net_bazzline_filesystem_watch_for_sync

