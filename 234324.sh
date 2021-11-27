#/usr/bin/env bash
red='\033[0;31m'
green='\033[0;32m'
yellow='\033[0;33m'
plain='\033[0m'

install_nvjdc(){
echo -e "${red}开始进行安装,请根据命令提示操作${plain}"
git clone https://github.com/btlanyan/nvjdc.git /root/nvjdc
cd /root/nvjdc && mkdir -p  .local-chromium/Linux-884014 && cd .local-chromium/Linux-884014
wget https://mirrors.huaweicloud.com/chromium-browser-snapshots/Linux_x64/884014/chrome-linux.zip && unzip chrome-linux.zip
echo -e "删除chrome-linux.zip"
rm  -f chrome-linux.zip > /dev/null 2>&1 
#rm  -f /root/nvjdc/Config/Config.json > /dev/null 2>&1
cd /root/nvjdc/Config
#cd .. && cd ..
read -p "请输入青龙服务器在web页面中显示的名称: " QLName && printf "\n"
read -p "请输入青龙OpenApi Client ID: " ClientID && printf "\n"
read -p "请输入青龙OpenApi Client Secret: " ClientSecret && printf "\n"
read -p "请输入青龙服务器的url地址（类似http://192.168.2.2:5700）: " QLurl && printf "\n"
read -p "请输入nvjdc面板希望使用的端口号: " jdcport && printf "\n"
cat >> Config.json << EOF
{
  ///最大支持几个网页
  "MaxTab": "4",
  //网站标题
  "Title": "NolanJDCloud",
  //网站公告
  "Announcement": "本项目脚本收集于互联网，为了您的财产安全，请关闭京东免密支付。",
  ///多青龙配置
  "Config": [
    {
      //序号必须从1开始
      "QLkey": 1,
      //服务器名称
      "QLName": "${QLName}",
      //青龙url
      "QLurl": "${QLurl}",
      //青龙2,9 OpenApi Client ID
      "QL_CLIENTID": "${ClientID}",
      //青龙2,9 OpenApi Client Secret
      "QL_SECRET": "${ClientSecret}",
      //青龙面包最大ck容量
      "QL_CAPACITY": 45,
      //消息推送二维码
      "QRurl":""
    }
  ]

}
EOF
#判断机器是否安装docker
if test -z "$(which docker)"; then
echo -e "检测到系统未安装docker，开始安装docker"
    curl -fsSL https://get.docker.com | bash -s docker --mirror Aliyun > /dev/null 2>&1 
    curl -L "https://github.com/docker/compose/releases/download/1.24.1/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose && chmod +x /usr/local/bin/docker-compose && ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose
fi
#cp -r /root/nvjdc/Config.json /root/nvjdc/Config/Config.json
#拉取nvjdc镜像
echo -e "开始拉取nvjdc镜像文件，nvjdc镜像比较大，请耐心等待"
docker pull shidahuilang/nvjdc:1.4
echo
cd  /root/nvjdc
echo -e "创建并启动nvjdc容器"
sudo docker run   --name nolanjdc -p ${jdcport}:80 -d  -v  "$(pwd)":/app \
-v /etc/localtime:/etc/localtime:ro \
-it --privileged=true  shidahuilang/nvjdc:1.4


baseip=$(curl -s ipip.ooo)  > /dev/null

echo -e "${green}安装完毕,面板访问地址：http://${baseip}:${jdcport}${plain}"
}
