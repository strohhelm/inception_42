#!/bin/bash

USERPASSWORD=$(cat /run/secrets/ftp_user_pw)

useradd $FTP_USER && echo "$FTP_USER:$USERPASSWORD" | chpasswd

echo "$FTP_USER" > /etc/vsftpd.user_list
mkdir -p /var/run/vsftpd/empty
chmod 755 /var/run/vsftpd/empty

# Create a writable directory for uploads
mkdir -p /home/ftpuser/
chown $FTP_USER:$FTP_USER /home/ftpuser
chmod 755 /home/ftpuser


vsftpd /etc/vsftpd.conf