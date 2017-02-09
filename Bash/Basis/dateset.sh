#!/bin/bash
echo "******************Task_Number_01******************\n"
echo "**************************************************\n\n\n"
echo "Start date(Format DD/MM/YYYY hh:mm): " ;read startday
echo "Start date(Format DD/MM/YYYY hh:mm): " ;read endday

## Firt we need to split the dates to re-organize the parameters position yyyy/mm/dd hh:mm:ss

day_st="$(echo $startday | cut -d / -f1)"
mon_st="$(echo $startday | cut -d / -f2)"
yea_st="$(echo $startday | cut -d / -f3 | cut -d ' ' -f1)"
hou_st="$(echo $startday | cut -d ' ' -f2)"

day_en="$(echo $endday | cut -d / -f1)"
mon_en="$(echo $endday | cut -d / -f2)"
yea_en="$(echo $endday | cut -d / -f3 | cut -d ' ' -f1)"
hou_en="$(echo $endday | cut -d ' ' -f2)"

#Convert Human Readable Date to Unix Epoch Time

dat_stux="$(date -d "$yea_st/$mon_st/$day_st $hou_st" +%s)"
dat_enux="$(date -d "$yea_en/$mon_en/$day_en $hou_en" +%s)"
echo $dat_enux
