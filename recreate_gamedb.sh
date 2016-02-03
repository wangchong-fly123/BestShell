#!/bin/bash

bin_dir=`dirname $0`
proj_home=$bin_dir/..
server_config_file=$proj_home/settings/server_config.xml
db_sql_file=$proj_home/settings/sql/gamedb.sql

if [ ! -f $server_config_file ]
then
    echo "$server_config_file is missing"
    exit 1
fi

if [ ! -f $db_sql_file ]
then
    echo "$db_sql_file is missing"
    exit 1
fi

db_info=$(sed -rn '
/<gamedb/s|'\
'.*<gamedb\s+'\
'host="(.*)"\s+'\
'port="(.*)"\s+'\
'name="(.*)"\s+'\
'user="(.*)"\s+'\
'password="(.*)"\s*/>.*'\
'|\1 \2 \3 \4 \5|p' \
$server_config_file)

read db_host db_port db_name db_user db_password <<< $db_info

echo "
DROP DATABASE IF EXISTS $db_name;
CREATE DATABASE $db_name CHARACTER SET utf8 COLLATE utf8_bin;
use $db_name;
source $db_sql_file;
" | mysql -h$db_host -P$db_port -u$db_user --password=$db_password

if [ $? -ne 0 ]
then
    exit 1
fi

exit 0
