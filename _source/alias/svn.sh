#!/bin/bash
####
# Contains svn dependend alias in alphabetically order
####
# @author stev leibelt <artodeto@bazzline.net>
# @since 2021-01-19
####

if [[ ${NET_BAZZLINE_SVN_IS_AVAILABLE} -eq 1 ]]
then
    alias svnDiff=net_bazzline_svn_diff
    alias svnRepositoryDiff=net_bazzline_svn_repository_diff
    alias svnLogGrep=net_bazzline_svn_log_grep
    alias svnRevertAll='svn revert -R .'
fi

