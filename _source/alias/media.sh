#!/bin/bash

#r
if [[ -f /usr/bin/cyanrip  ]];
then
  alias ripCdAsMp3=net_bazzline_media_rip_cd_as_mp3
fi
if [[ -f /usr/bin/vobcopy ]] && [[ -f /usr/bin/ffmpeg ]];
then
  alias ripDvdAs265Mkv=net_bazzline_media_rip_dvd_to_x265
fi
