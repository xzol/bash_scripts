#!/bin/bash

username=$1
developerGroupName="developers"

#Создаём пользователя
/usr/sbin/adduser $username

#Добавляем в группу developers
existGroupDeveloper=`cat /etc/group | grep "developers"`
if [[ "$existGroupDeveloper" = "" ]]; then
	/usr/sbin/addgroup $developerGroupName
	echo "Группа добавлена."
else 
	echo "Группа уже существует."	
fi

#Добавляем пользователя в группу
/usr/sbin/usermod -aG $developerGroupName $username
/usr/sbin/usermod -g $developerGroupName




