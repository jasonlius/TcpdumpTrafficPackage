#!/bin/bash
FILE=/etc/TcpdumpTrafficPackage
SERVICE_PATH=/lib/systemd/system/
TRAFFIC_CAP_SERVICE=/lib/systemd/system/tcpdumpTrafficCapture.service
echo 一键部署开始执行
echo 请输入管理员密码
sudo apt-get install tcpdump
sudo apt-get install git
echo 必要软件安装完成！
echo 开始创建抓包文件夹
cd '/etc'
if [ -d "$FILE" ]; then
        echo "已经存在该文件夹TcpdumpTrafficPackage"
        sudo rm -rf $FILE
        sudo git clone https://github.com/jasonlius/TcpdumpTrafficPackage.git
else
        sudo git clone https://github.com/jasonlius/TcpdumpTrafficPackage.git
fi

if [ -f "/etc/init.d/tcpdumpTrafficCapture-server" ]; then
        echo 已经存在该抓包脚本，重新创建
        sudo rm -rf /etc/init.d/tcpdumpTrafficCapture-server
        sudo cp $FILE/tcpdumpTrafficCapture-server /etc/init.d
else
        sudo cp $FILE/tcpdumpTrafficCapture-server /etc/init.d
        echo 创建抓包脚本成功！
fi

echo 开始创建系统Service服务
cd $SERVICE_PATH

if [ -f "$TRAFFIC_CAP_SERVICE" ]; then
        echo 已经存在该服务，重新创建
        sudo rm -rf $TRAFFIC_CAP_SERVICE
        sudo cp $FILE/tcpdumpTrafficCapture.service $SERVICE_PATH
else
        sudo cp $FILE/tcpdumpTrafficCapture.service $SERVICE_PATH
        echo 创建服务成功！
fi
echo 服务加入开机启动中
sudo systemctl daemon-reload
sudo systemctl enable tcpdumpTrafficCapture.service
echo 服务开机启动完成
echo 查看服务开启状态
sudo systemctl status tcpdumpTrafficCapture.service
cd $HOME
echo 部署完成，请按Q键退出。
