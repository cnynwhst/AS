#!/bin/bash 
/usr/local/sbin/nginx  -s stop 
rm -rf /usr/local/nginx/
yum -y install gcc openssl-devel pcre-devel   
useradd -s /sbin/nologin  nginx 
find1=$(find /  -type f -name "nginx-1.1*")
for i in $find1
do
	if [ -z $i ];then
		echo -e "\033[31m没有Nginx源码包\033[0m"
		exit	
	fi
	tar -xf $i 	
	echo -e "\033[31m$i\033[0m"
done
read -p "请输入你要安装的版本(nginx-x.x.x)" a
cd ${a:-nginx-1.12.2}
read -p  "—————————————————————请输入选项—————————————————————
1.user=nginx   
2.group=nginx  
3.with-http_ssl_module
4.with-http_stub_status_module 
5.with-stream
"  xuanxiang
for ii in    $xuanxiang
do
	case $ii  in
	1)
	  i1=" --user=nginx "
	  ;;
	2)
	  i1=" --group=nginx "
	  ;;
	3)
	  i1=" --with-http_ssl_module "
	  ;;
	4)
	  i1=" --with-http_stub_status_module "
	  ;;
	5)
	  i1=" --with-stream "
	  ;;
	*)
	  i1=" "
	esac
	i2=" $i2 $i1 "
done

echo -e "—————————————————————请输入选项—————————————————————"
echo -e "\033[31m$i2\033[0m"
read -p "请确认您的选项(回车继续)" i3
if [ ! -z $i3 ];then
	exit
fi	
./configure   $i2 
make && make install
read -p "是否安装php（输入任意值安装，回车跳过）"   php
if [ ! -z $php ];then
	find2=$(find /  -type f -name "php-fpm*.rpm")
	if [ -z $find2 ];then	
		echo -e "\033[31m没有php-fpm源码包\033[0m"
		exit
		else
		echo -e "\033[31m****************************正在安装************************************\033[0m"
		echo "正在安装php-fpm"
		yum -y install $find2 &> /dev/null
		echo "php-fpm安装成功"
		echo "正在安装php"
		yum -y install php &> /dev/null
		echo "php安装成功"
		echo "正在安装php-mysql" 
		yum -y install php-mysql &> /dev/null 
		echo "php-mysql安装成功"
		echo -e "\033[31m***************************正在重启服务**********************************\033[0m"
		systemctl restart php-fpm
		echo -e "\033[31m************************ 正在设置开机自启**********************************\033[0m"
		systemctl enable php-fpm
		echo -e "\033[31m***************************php安装完成**********************************\033[0m"
	fi
		
fi
read -p "是否安装mariadb（输入任意值安装，回车跳过）"  mariadb
if [ ! -z $mariadb ];then
	echo -e "\033[31m****************************正在安装************************************\033[0m"
	echo  "正在安装mariadb"
	yum -y install mariadb &> /dev/null
	echo "mariadb安装完成"
	echo "正在安装mariadb-server" 
	yum -y install mariadb-server &> /dev/null
	echo "mariadb-server安装完成"
	echo "正在安装mariadb-devel"   
	yum -y install mariadb-devel &> /dev/null
	echo "mariadb-devel安装完成"
	echo -e "\033[31m***************************正在重启服务**********************************\033[0m"
	systemctl restart  mariadb 
	echo -e "\033[31m************************ 正在设置开机自**********************************\033[0m"
	systemctl enable mariadb 
	echo -e "\033[31m***************************php安装完成**********************************\033[0m"
fi
echo -e "\033[31m*************************正在关闭http80端口**********************************\033[0m"
systemctl stop httpd 
echo -e "\033[31m***************************正在重启nginx服务**********************************\033[0m" 
/usr/local/nginx/sbin/nginx  
echo -e "\033[31mLNMP安装完成\033[0m"

