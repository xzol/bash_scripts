#!/bin/bash
userName=$2
urlGolangForDownload="https://golang.org/dl/"

#смотрим на сайта: https://golang.org/dl/
#Вставляем так: go1.16.6.linux-amd64.tar.gz
urlVersionGolangTarGz=$1

function askYesNo {
        QUESTION=$1
        DEFAULT=$2
        if [ "$DEFAULT" = true ]; then
                OPTIONS="[Y/n]"
                DEFAULT="y"
            else
                OPTIONS="[y/N]"
                DEFAULT="n"
        fi
        read -p "$QUESTION $OPTIONS " -n 1 -s -r INPUT
        INPUT=${INPUT:-${DEFAULT}}
        echo ${INPUT}
        if [[ "$INPUT" =~ ^[yY]$ ]]; then
            ANSWER=true
        else
            ANSWER=false
        fi
}

if [ $urlVersionGolangTarGz = "" ]; then
	echo "Need version golang. Please see: https://golang.org/dl/"
	exit 0
fi

####################Download########################
if [ -f $urlVersionGolangTarGz ]; then
	echo "Данная версия уже скачана."
else

    echo "Start download golang"
    #скачиваем
    /usr/bin/wget $urlGolangForDownload$urlVersionGolangTarGz

    #Проверяем целостность архива
    sha256sum=`/usr/bin/sha256sum $urlVersionGolangTarGz`

    echo $sha256sum
    echo "End download. See check summ!"

    askYesNo "Sha256sum верна?" true
    DOIT=$ANSWER
    if [ "$DOIT" = false ]; then
        echo "Суммы должны совпадать!"	
        exit 2
    else
        echo "Чек сумма проверена."	
    fi
fi
##################Install###########################
pathNameGo="go"
pathToRootGo="/usr/local/"$pathNameGo


if [ -f $pathNameGo ]; then
    echo "Каталок 'go' уже существует."
else
    extract=`/usr/bin/tar xf $urlVersionGolangTarGz`
    if $extract; then 
    	echo "Распаковано."
    else
	echo "Ошибка при распаковке."	
	exit 3
    fi 
fi

resChown=`/usr/bin/chown -R root:root $pathNameGo`
if $resChown; then
    echo "Права даны root:root"
else
    echo "Права на проставились."
    exit 4
fi

moveGo=`/usr/bin/mv $pathNameGo /usr/local/$pathNameGo`
if $moveGo; then
    echo "Перемещено в /usr/local"
else
    echo "Не удалось переместить в /usr/local"
fi

#####################.PROFILE###################

if [ -z $userName ]; then
    echo "Не указан пользователь."	
    echo "Пропишите GOROOT и GOPATH ручками в ~/.profile"
    echo "export GOPATH=$pathToRootGo"
    echo "export GOROOT=$pathToRootGo"
    echo "export PATH=$PATH:$pathToRootGo/bin"
else
	echo "1-$userName-1"
    echo "export GOPATH=$pathToRootGo" >> /home/$userName/.profile
    echo "export GOROOT=$pathToRootGo" >> /home/$userName/.profile
    echo "export PATH=$PATH:$pathToRootGo/bin" >> /home/$userName/.profile
    echo "GOROOT и GOPATH прописаны"
fi
