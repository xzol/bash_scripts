#!/bin/bash
userName=$1

if [[ $userName = "" ]]; then
    echo "Необходимо имя пользователя."
    exit 1   
fi

curl -L https://github.com/docker/compose/releases/download/1.25.3/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose

chmod +x /usr/local/bin/docker-compose

vesrsion=`docker-compose --version`
echo $version

#Добавляем пользователя в группу
resUserName=`/usr/sbin/usermod -aG docker $userName`
echo "$resUserName"
if $resUserName; then
    echo "Пользователь добавлен в группу 'docker'"
else
    echo "Пользователь не добавлен в группу"
fi
