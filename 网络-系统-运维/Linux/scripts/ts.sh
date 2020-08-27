#!/bin/bash
echo "###############################################"
echo "1.删除头部部分视频"
echo "2.删除尾部部分视频"
echo "3.替换头部部分视频"
echo "###############################################"
read -p 'Please enter choice[1-3]:' choice
read -p 'Please enter m3u8 file:' m3u8
read -p 'Please enter time:' start_time
cp -f $m3u8 ${m3u8}-$(date +%Y%m%d)
count=0
i=4
case $choice in
1)
  # 删除头部部分ts文件
  for ts_time in $(awk -F"[:]" '/#EXTINF/{print $2}' $m3u8)
  do
    if [ $(echo "${start_time}>=$count" | bc) -eq 1 ];then
      count=$(echo "scale=3;$count+$ts_time" | bc)
    else 
      break
    fi
    i=$[i+2]
  done
  sed -i "5,${i}d" $m3u8;;
2)
  # 删除尾部部分ts文件
  for ts_time in $(awk -F"[:]" '/#EXTINF/{print $2}' $m3u8)
  do
    if [ $(echo "${start_time}>=$count" | bc) -eq 1 ];then
      count=$(echo "scale=3;$count+$ts_time" | bc)
    fi
    i=$[i+2]
  done
  end=$[ $(cat $m3u8 | wc -l) - 1 ]
  sed -i "$i,${end}d" $m3u8;;
3)
  # 替换头部部分视频
  read -p 'Please enter mp4:' mp4
  for ts_time in $(awk -F"[:]" '/#EXTINF/{print $2}' $m3u8)
  do
    if [ $(echo "${start_time}>=$count" | bc) -eq 1 ];then
      count=$(echo "scale=3;$count+$ts_time" | bc)
    else 
      break
    fi
    i=$[i+2]
  done
  sed -i "5,${i}d" $m3u8
  /sbin/ffmpeg -y -loglevel error -nostdin -i ${mp4} -fflags +genpts+igndts+discardcorrupt -codec copy -bsf:v h264_mp4toannexb -map 0 -f segment -segment_time 2 -segment_list output.m3u8 %d.ts
  sed -i '1,5d' output.m3u8
  sed -i '$d' output.m3u8
  sed -i '$a #EXT-X-DISCONTINUITY' output.m3u8
  sed -i '4r output.m3u8' $m3u8;;
*)
  echo "请输入可选值(1-3)";;
esac
  
