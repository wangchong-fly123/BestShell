#!/bin/bash

script_abs_name=`readlink -f $0`
script_path=`dirname $script_abs_name`
server_config_file=$script_path/../settings/server_config.xml

if [ ! -f $server_config_file ]
then
    echo "$server_config_file is missing"
    exit 1
fi

var_dir=$(sed -rn \
'/<var/s|'\
'.*<var\s+'\
'dir="(.*)"\s*/>.*'\
'|\1|p' \
$server_config_file)

if [ -z "$var_dir" ]
then
    mkdir $script_path/actiondb
    mkdir $script_path/actionlog
    mkdir $script_path/log
    mkdir $script_path/data_backup
else
    if [ ! -d "$var_dir" ]
    then
        echo "$var_dir not exist"
        exit 1
    fi
    ln -s $var_dir/actiondb
    ln -s $var_dir/actionlog
    ln -s $var_dir/log
    ln -s $var_dir/data_backup
fi

exit 0
