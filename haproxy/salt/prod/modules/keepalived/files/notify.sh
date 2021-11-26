#!/bin/bash
VIP=$2
sendmail (){
        subject="${VIP}'s server keepalived state is translate"
        content="`date +'%F %T'`: `hostname`'s state change to master"
        echo $content | mail -s "$subject" 3199560936@qq.com
}
case "$1" in
  master)
        nginx_status=$(ps -ef|grep -Ev "grep|$0"|grep '\bnginx\b'|wc -l)
        if [ $nginx_status -lt 1 ];then
            systemctl start nginx
        fi
        sendmail
  ;;
  backup)
        nginx_status=$(ps -ef|grep -Ev "grep|$0"|grep '\bnginx\b'|wc -l)
        if [ $nginx_status -gt 0 ];then
            systemctl stop nginx
        fi
  ;;
  *)
        echo "Usage:$0 master|backup VIP"
  ;;
esac
