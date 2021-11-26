#!/bin/bash
nginx_status=$(ps -ef|grep -Ev "grep|$0"|grep '\bnginx\b'|wc -l)
if [ $nginx_status -lt 1 ];then
	    systemctl stop keepalived
fi
