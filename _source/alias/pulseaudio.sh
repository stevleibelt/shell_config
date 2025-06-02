#!/bin/bash
####
# Contains pulseaudio dependend alias in alphabetically order
####
# @author stev leibelt <artodeto@bazzline.net>
# @since 2021-01-19
####

if [[ ${NET_BAZZLINE_PULSEAUDIO_IS_AVAILABLE} -eq 1 ]];
then
  #p
  alias pulseaudio-equalizer=qpaeq

  #r
  alias restartPulseAudio='sudo killall pulseaudio && systemctl --user restart pulseaudio.service'
fi
