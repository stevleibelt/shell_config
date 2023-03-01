#!/bin/bash

#l
if [[ ${NET_BAZZLINE_PRINTER_IS_AVAILABLE} -eq 1 ]];
then
  alias listCupsPrintingJobs='echo ":: Calling lpstat"; lpstat'
fi
