#!/bin/bash
username=$1
sudo -u $1 ssh-keygen
sudo -u $1 cat /home/$1/.ssh/id_rsa.pub

