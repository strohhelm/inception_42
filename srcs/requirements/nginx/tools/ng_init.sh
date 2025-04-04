#!/bin/bash

openssl req	-x509 \
			-nodes \
			-newkey rsa:2048 \
			-keyout /etc/ssl/nginx.key \
			-out /etc/ssl/nginx.crt \
			-days 365 \
			--subj "/CN=DE/"

nginx -g "daemon off;"