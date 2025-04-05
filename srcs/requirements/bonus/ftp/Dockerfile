FROM debian:bullseye

RUN apt-get update && apt install -y vsftpd ftp

COPY conf/vsftpd.conf /etc/vsftpd.conf
COPY tools/ftp_init.sh .
RUN chmod +x ftp_init.sh

EXPOSE 21
ENTRYPOINT ["./ftp_init.sh"]