#!/bin/bash
####
# Contains general aliases in alphabetically order
####
# @author stev leibelt <artodeto@bazzline.net>
# @since 2013-04-24
####

#.
alias ..='cd ..'

#a
alias abcde='abcde -S 12'
alias ant='ant -logger org.apache.tools.ant.listener.AnsiColorLogger'

#b
alias batchConvertImageTo640=net_bazzline_image_batch_convert_640
alias batchConvertImageTo1024=net_bazzline_image_batch_convert_1024
alias batchConvertImageTo1920=net_bazzline_image_batch_convert_1920
alias batchConvertImageTo4096=net_bazzline_image_batch_convert_4096
alias batchConvertImageToJpg=net_bazzline_image_batch_convert_to_jpg
alias batchConvertVideoToLibx264=net_bazzline_batch_convert_video_to_libx264
alias batchConvertVideoToLibx265=net_bazzline_batch_convert_video_to_libx265
#alias batchConvertVideoToLibrav1e=net_bazzline_batch_convert_video_to_librav1e
alias batchDirectoryPathToLower=net_bazzline_batch_directory_path_to_lower
alias batchFilePathToLower=net_bazzline_batch_file_path_to_lower
alias bootstrapShellConfigurationInVerboseMode='net_bazzline_shell_config_bootstrap 1'
alias burn=net_bazzline_burn

#c
alias c=clear
if [[ -x $(command -v tee) ]];
then
  alias captureCommandOutput=net_bazzline_core_capture_command_output
fi
alias cd=net_bazzline_cd
alias cdToTheShellConfiguration="cd ${PATH_SHELL_CONFIG}"
alias checkExt4Device=net_bazzline_check_ext4_device
alias checkFatDevice=net_bazzline_check_fat_device
alias cleanupAfterConvertingFiles=net_bazzline_cleanup_after_converting_files
alias compileC++11='c++ -std=c++11'
alias compileC++14='c++ -std=c++14'
alias compress=net_bazzline_compress
alias compressPdf=net_bazzline_media_book_compress_pdf
alias convertImageToJPEG=net_bazzline_image_convert_to_jpg
alias convertImageToWebp=net_bazzline_image_convert_to_webp
alias convertFileNamesToUtf8=net_bazzline_convert_file_names_to_utf_8
alias convertM4aToWav=net_bazzline_convert_m4a_to_wav
alias convertMp4ToMp3=net_bazzline_convert_mp4_to_mp3
alias convertMp3ToWav=net_bazzline_convert_mp3_to_wav
alias convertMarkdownFilesToOnePdf=net_bazzline_media_book_convert_markdown_files_to_one_pdf
alias convertMkvToAvi=net_bazzline_convert_mkv_to_avi
alias convertTimestampToDate=net_bazzline_date_convert_from_timestampe
alias convertVideoToScreenSize=net_bazzline_convert_video_to_screen_size
alias convertVideoToLibx264=net_bazzline_convert_video_to_libx264
alias convertVideoToLibx265=net_bazzline_convert_video_to_libx265
alias convertVideoToLibrav1e=net_bazzline_convert_video_to_librav1e
alias convertWavToMp3=net_bazzline_convert_wav_to_mp3
alias createAMp3FileForEachMpcFileInTheCurrentWorkingDirectory=net_bazzline_create_a_mp3_file_for_each_mpc_file_in_the_current_directory
alias createNewSshKey='ssh-keygen -a 420 -b 4096 -t rsa'
alias createNewSshEdKey='ssh-keygen -a 420 -b 521 -t ed25519'
alias createPathOrReturnErrorIfPathExistsAlready=net_bazzline_create_path_or_return_error_if_path_exists_already

#d
alias decompress=net_bazzline_decompress
alias deleteEmptyDirectories=net_bazzline_delete_empty_directories
alias deleteFilesOlderThan=net_bazzline_delete_files_older_than
alias diff='diff --color=auto'
alias diffTwoPaths=net_bazzline_diff_two_paths

#f
alias filesystemPathToLower=net_bazzline_filesystem_path_to_lower
alias findBrokenSymlinks='find -type l -! -exec test -e {} \; -print'
alias findDirectory=net_bazzline_find_directory
alias findFile=net_bazzline_find_file
alias findAllPacFiles='find / -regextype posix-extended -regex ".+\.pac(new|save|orig)" 2> /dev/null'
alias findSymlinks='find -type l'
if [[ ${NET_BAZZLINE_FWUPDMGR_IS_AVAILABLE} -eq 1 ]];
then
  alias firmware-update="fwupdmgr refresh; fwupdmgr update;"
fi

#g
alias getExtensionFromFilename=net_bazzline_get_extension_from_filename
alias getFilenameFromFilepath=net_bazzline_get_filename_from_filepath
alias getNameFromFilename=net_bazzline_get_name_from_filename
alias grep='grep --color=auto --exclude=\*.svn\*'

#h
alias hideFileSystemObject=net_bazzline_hide_file_system_object

#i
alias iftop='iftop -P -B'
alias ip='ip -color=auto'
if [[ -f /usr/bin/iostat ]];
then
  alias iostat='iostat -x 2'
fi

#l
alias l='ls -hAlt --color=auto'
alias lh=net_bazzline_list_filesystem_items_head
alias listDomainInformation=net_bazzline_list_domain_information
alias listEmptyDirectories=net_bazzline_list_empty_directories
alias listFilesOlderThan=net_bazzline_list_files_older_than
alias listGroups=net_bazzline_list_groups
alias listInodes=net_bazzline_list_inodes
alias listInterfaces=net_bazzline_list_interfaces
alias listLocalIpAddress=net_bazzline_list_local_ip_address
alias listMemoryUsageByProcess=net_bazzline_list_memory_usage_by_process
alias listOpenNetworkPorts='lsof +M -i4 -i6'
alias listProcessEnvironment=net_bazzline_list_process_environment
alias listSoftLinks=net_bazzline_list_softlinks
alias listSymbolicLinks=net_bazzline_list_symbolic_links
alias listUsers=net_bazzline_list_users
alias loadVirtualBoxModules='sudo modprobe -a vboxdrv vboxnetadp vboxnetflt vboxpci'
alias lt=net_bazzline_list_filesystem_items_tail
alias luksDumpInformation=net_bazzline_luks_dump_information
alias luksHeaderBackup=net_bazzline_luks_header_backup
alias luksHeaderRestore=net_bazzline_luks_header_restore

#m
alias makePictureViaWebcam=net_bazzline_make_picture_via_webcam
alias mergeAudioAndVideo=net_bazzline_merge_audio_and_video
alias mkdir=net_bazzline_mkdir
alias mkdirPrefixCurrentDate=net_bazzline_mkdir_prefix_with_current_date
alias mkdirWithTheNameOfTheCurrentDate=net_bazzline_mkdir_with_the_name_of_the_current_date
alias monitorProcess=net_bazzline_monitor_process
alias moveInChunks=net_bazzline_move_in_chunks

#n
alias netstatListRunningServices='netstat -tulpen'

#o
alias obay=sudo
alias organizeDirectoryContent=net_bazzline_organize_directory_content

#p
alias psGrep=net_bazzline_psgrep

#r
alias r='rm -fr';
alias refreshInterface='net_bazzline_refresh_interface'
alias relogin='bash -l'
alias reloadBashEnvironment='source ~/.bashrc; clear;'
if [[ -f /usr/bin/docker ]];
then
  alias removeAllDockerContainers='docker ps -a -q | docker stop && docker ps -a -q | xargs docker rm'
fi
alias renameAllToLower=net_bazzline_filename_to_lower_batch_rename
alias renameGitBranch=net_bazzline_rename_git_branch
alias replaceStringInFiles=net_bazzline_replace_string_in_files
if [[ -x $(command -v tee) ]];
then
  alias returnCommandOutput=net_bazzline_core_return_command_output
fi
if [[ -x $(command -v rsync) ]];
then
 alias rsync=net_bazzline_rsync
fi
alias runJar='java -jar '

#s
alias searchInComposerFiles=net_bazzline_search_in_composer_files
alias setOpticalDriveSpeed=net_bazzline_set_optical_drive_speed
alias silentGrep=net_bazzline_silent_grep
alias searchAndReplaceInFiles=net_bazzline_replace_string_in_files
alias scanNetworkForIpAddressRange=net_bazzline_scan_network
alias scpFromHost=net_bazzline_scp_from_host
alias scpToHost=net_bazzline_scp_to_host
alias shuffelNumber=net_bazzline_shuffle_number
alias showSystemTemperature=sensors
alias showSystemUsers=net_bazzline_show_system_users
alias startSshAgent='eval $(ssh-agent)'
alias startXorg='startx; exit'
alias syncFromHost=net_bazzline_sync_from_host
alias syncTime='ntpd -s'
alias syncTo=net_bazzline_sync_to
alias syncToHost=net_bazzline_sync_to_host

#t
alias takeScreenshot=net_bazzline_screenshot
alias tarCreate=net_bazzline_tar_create
alias tarExtract=net_bazzline_tar_extract
alias tarList=net_bazzline_tar_list
alias testConnection='clear && curl https://resttest.bazzline.net'
alias touchPrefixCurrentDate=net_bazzline_touch_with_prefix_of_current_date

#u
alias updateAllRepositories=net_bazzline_git_update_all_repositories
alias updateShellConfiguration=net_bazzline_update_shell_configuration
alias updateVimBundlesAndPluginsWithVundle=net_bazzline_update_vim_bundles_and_plugins_with_vundle
alias unhideFileSystemObject=net_bazzline_unhide_file_system_object

#v
alias v=vim

#w
alias watchForSystemTemperatur="watch -n10 'sensors'"
alias whatIsListeningOnPort=net_bazzline_what_is_listening_on_that_port

#x
alias x=exit
alias xinit='startx; exit'
