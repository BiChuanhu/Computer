#!/bin/bash
# 获取本机的MAC地址
# awk读取ip命令的输出，输出结果中如果有以数字开始的行，先显示改行的第二列(网卡名称)
# 如果有该关键词，就显示改行的的第二列(MAC地址)
# lo回环设备没有MAC，因此将其屏蔽,不显示
ip a s | awk 'BEGIN{print "本机MAC地址信息如下:"}/^[0-9]/{print $2;getline;if($0~/link\/ether/){print $2}}' | grep -v lo
