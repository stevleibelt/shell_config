#!/bin/bash

#c
alias cdToCurrentUserGvfs='cd /run/user/${UID}/gvfs'
alias createSha512sumFromFile=net_bazzline_filesystem_create_sha512sum_from_file

#e
alias emptyTmp=net_bazzline_filesystem_generic_empty_tmp

#f
alias fixQuotes=net_bazzline_filesystem_generic_fix_quotes

#l
alias listBiggestSwapSpaceConsumers=net_bazzline_filesystem_list_biggest_swap_space_consumers
alias listBiggestDirectories=net_bazzline_filesystem_list_biggest_directories
alias listLatestFile="ls -t | head -n 1"
alias lsGrep=net_bazzline_filesystem_ls_grep

#o
alias openLatestFile='$EDITOR $(listLatestFile)'

#w
alias watchForSync=net_bazzline_filesystem_watch_for_sync

