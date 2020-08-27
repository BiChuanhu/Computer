#!/bin/bash
# 在proc目录下所有以数字开头的都是当前计算机正在运行的进程的进程PID
# 每个PID进程的目录下记录有该进程的相关信息
# 每个PID目录下都有一个stat文件，该文件的第三列是该进程的状态信息
while :
running=0
stoped=0
sleeping=0
zombie=0
do
  for pid in /proc/[1-9]*
  do
    procs=$[procs+1]
    stat=$(awk '{print $3}' $pid/stat)
    case $stat in
    R)
      running=$[running+1];;
    T)
      stoped=$[stoped+1];;
    S)
      sleeping=$[sleeping+1];;
    Z)
      zombie=$[zombie+1];;
    esac
  done
  echo "进程统计信息如下:"
  echo "总进程数量为:$procs"
  echo "Running进程数为:$running"
  echo "Stoped进程数为:$stoped"
  echo "Sleepging进程数为:$sleeping"
  echo "Zombie进程数为:$zombie"
  sleep 1
  clear
done
