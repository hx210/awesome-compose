#!/usr/bin/env bash
mkdir openwrt
sudo apt update
sudo apt install -y net-tools

# docker network create -d macvlan --subnet=10.0.0.0/24 --gateway=10.0.0.1 -o parent=ens33 openwrt_net
# docker run --restart always -d --network openwrt_net --privileged -v /lib/modules:/lib/modules --label=com.centurylinklabs.watchtower.monitor-only=true --dns=223.5.5.5 rx21/openwrt:x86_64 /sbin/init

# https://github.com/SuLingGG/OpenWrt-Docker/issues/19

start_path="/etc/init.d/openwrt-net.sh"
cat >${start_path} <<EOF
#!/bin/sh
set -e
# 开启网卡混杂防止无网

ip link add link [宿主机接口名] dev [宿主机接口名].01 type macvlan mode bridge
ifconfig [宿主机接口名].01 [中转用的ip同网段即可]/24
route add [OPip] dev [宿主机接口名].01
route add default gw [OPip] dev [宿主机接口名].01
# 解决宿主机使用op网关无网

# op容器dns错误 导致仅op无网 需要指定dns luci界面修改无效
EOF

chmod +x ${start_path}
# 添加执行权限

echo "输入crontab -e 添加"
echo "@reboot sh ${start_path}"
