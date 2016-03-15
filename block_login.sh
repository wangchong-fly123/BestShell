#!/bin/bash

usage()
{
    echo "usage: `basename $0` <start|stop|status>"
    exit 1
}

if [ $# -ne 1 ]
then
    usage
    exit 1
fi

script_abs_name=`readlink -f $0`
script_path=`dirname $script_abs_name`
server_config_file=$script_path/../settings/server_config.xml
allow_login_ip_file=$script_path/../settings/allow_login_ip.txt

if [ ! -f $server_config_file ]
then
    echo "$server_config_file is missing"
    exit 1
fi

if [ ! -f $allow_login_ip_file ]
then
    echo "$allow_login_ip_file is missing"
    exit 1
fi

port=$(sed -rn \
'/<socialserver/s|'\
'.*<socialserver.*'\
'port="(.*)"\s*'\
'|\1|p' \
$server_config_file)

allow_ip_list=`cat $allow_login_ip_file`
block_login_chain=BLOCK_LOGIN_$port

op_check_root()
{
    user_id=`id -u`
    if [ $user_id != '0' ]
    then
        echo "must run by root"
        exit 1
    fi
}

op_start()
{
    op_stop
    iptables -N $block_login_chain
    for allow_ip in $allow_ip_list
    do
        iptables -A $block_login_chain -s $allow_ip -p tcp --dport $port -j ACCEPT
    done
    iptables -A $block_login_chain -p tcp --dport $port -j REJECT
    iptables -A INPUT -j $block_login_chain
}

op_stop()
{
    iptables -D INPUT -j $block_login_chain 2>/dev/null
    iptables -F $block_login_chain 2>/dev/null
    iptables -X $block_login_chain 2>/dev/null
}

op_status()
{
    iptables -vnL
}

case "$1" in
    start)
        op_check_root
        op_start
        op_status
        ;;
    stop)
        op_check_root
        op_stop
        op_status
        ;;
    status)
        op_check_root
        op_status
        ;; 
    *)
        usage
        ;;
esac

exit 0
