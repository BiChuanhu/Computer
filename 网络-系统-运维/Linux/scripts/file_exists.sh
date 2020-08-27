#!/bin/bash
# 判断文件或目录是否存在
if [ $# -eq 0 ];then
  echo "未输入任何参数，请输入参数"
  echo "用法:$0 [文件名|目录名]"
elif [ $# -eq 1 ];then
  if [ -f $1 ];then
    echo "该文件存在"
    ls -l $1
  elif [ -d $1 ];then
    echo "该目录存在"
    ls -ld $1
  else
    echo "该文件或目录不存在"
  fi
else
  echo "参数过多"
fi

