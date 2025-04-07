#!/bin/bash

USERPASSWORD=$(cat /run/secrets/ftp_user_pw)

if [ ! "$(cat /etc/passwd | grep $FTP_USER)" ]
then
	echo "[FTP_SERVER] adding user and setting up permissions"
	useradd $FTP_USER
	echo "$FTP_USER:$USERPASSWORD" | chpasswd
	echo "$FTP_USER" > /etc/vsftpd.user_list

	mkdir -p /var/run/vsftpd/empty
	chmod 755 /var/run/vsftpd/empty
	# owning the driectory where the wp volume will be mounted
	chown -R $FTP_USER:$FTP_USER /var/www/html
else
	echo "[FTP_SERVER] already set up"
fi

vsftpd /etc/vsftpd.conf