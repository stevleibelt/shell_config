#!/bin/bash

#e
# ref: https://bbs.archlinux.org/viewtopic.php?pid=2247728#p2247728
if [[ -f /usr/bin/element-desktop ]];
then
  if [[ -f /usr/bin/gnome-keyring ]];
  then
    # prevents error message
    # > Your system has an unsupported keyring meaning the database cannot be opened
    alias element-desktop='element-desktop --password-store="gnome-libsecret"'
  fi
fi

#f
if [[ -f /usr/bin/ffmpeg ]];
then
  alias batchConvertFlacToMp3=net_bazzline_media_batch_convert_flac_to_mp3
  alias convertFlacToMp3=net_bazzline_media_convert_flac_to_mp3
  alias convertVideoToMkv=net_bazzline_convert_video_to_mkv
fi

#n
if [[ -f /usr/bin/naps2 ]];
then
  alias addOcrToPdf=net_bazzline_media_book_add_ocr_to_pdf
fi

#w
if [[ -f /usr/bin/whipper  ]];
then
  alias ripCdAsMp3='whipper cd rip'
elif [[ -f /usr/bin/cyanrip  ]];
then
  alias ripCdAsMp3=net_bazzline_media_rip_cd_as_mp3_with_cyanrip
fi

#v
if [[ -f /usr/bin/vobcopy ]] && [[ -f /usr/bin/ffmpeg ]];
then
  alias ripDvdAsMkv=net_bazzline_media_rip_dvd_to_mkv
fi
