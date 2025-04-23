#!/bin/bash

#a

#special
if [[ -f /usr/bin/naps2 ]];
then
  alias addOcrToPdf=net_bazzline_media_book_add_ocr_to_pdf
fi

if [[ -f /usr/bin/ffmpeg ]];
then
  alias batchConvertFlacToMp3=net_bazzline_media_batch_convert_flac_to_mp3
  alias convertFlacToMp3=net_bazzline_media_convert_flac_to_mp3
  alias convertVideoToMkv=net_bazzline_convert_video_to_mkv
fi

if [[ -f /usr/bin/whipper  ]];
then
  alias ripCdAsMp3='whipper cd rip'
elif [[ -f /usr/bin/cyanrip  ]];
then
  alias ripCdAsMp3=net_bazzline_media_rip_cd_as_mp3_with_cyanrip
fi

if [[ -f /usr/bin/vobcopy ]] && [[ -f /usr/bin/ffmpeg ]];
then
  alias ripDvdAsMkv=net_bazzline_media_rip_dvd_to_mkv
fi
