#!/bin/bash

script_name=`basename $0`

bin_dir=`dirname $0`
proj_home=$bin_dir/..
server_config_file=$proj_home/settings/server_config.xml

if [ ! -f $server_config_file ] 
then
    echo "$server_config_file is missing"
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

backup_dir=$bin_dir/data_backup/ #备份文件存储路径
logfile=data_backup.log #日志文件
now=`date '+%Y%m%d-%H%M'` #日期格式（文件名）
dumpfile=${now}.sql
tarfile=${now}.sql.tgz

#判断文件目录是否存在,否则创建该目录
if [ ! -d $backup_dir ] ;
then
    mkdir -p "$backup_dir"
fi

#切换目录开始备份
cd $backup_dir
#开始备份之前，将备份信息写入日志文件
echo " " >> $logfile
echo "-----------------" >> $logfile
echo "DATABASE NAME: $db_name" >> $logfile
echo "BACKUP DATE: $(date +"%y-%m-%d %H:%M:%S")" >> $logfile
echo "-----------------" >> $logfile

mysqldump -h$db_host -P$db_port -u$db_user --password=$db_password $db_name> $dumpfile 2>>$logfile 

#判断数据库备份是否成功
if [[ $? == 0 ]]; then
    #压缩包
    tar zcvf $tarfile $dumpfile  >> $logfile 2>&1

    echo "[$tarfile] Backup Successed!"  >> $logfile

    rm -f $dumpfile
else
    echo "DataBase Backup Failed！">> $logfile
fi

echo "Backup Process Done"

exit 0
