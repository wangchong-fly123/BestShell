#!/bin/bash

update_user_config()
{
    local user_name=$1
    local db_name=$2
    local server_no=$3
    local host_ip=$4
    local map_ip=$5
    local battle_server_count=$6

    ssh $user_name@$host_ip "
    cd ~/server2/settings/template && \
    svn up && \
    ./copy_conf.sh $db_name $server_no $map_ip $battle_server_count \
    "

    echo "===$user_name config change done!==="
}

update_dev_server_config()
{
    local dir_name=$1
    local db_name=$2
    local server_no=$3
    local host_ip=$4
    local map_ip=$5
    local battle_server_count=$6

    dir=~/workspace/$dir_name/TSSG_CODE/trunk/source/server2/settings/template
    cd $dir && \
    svn up && \
    ./copy_conf.sh $db_name $server_no $map_ip $battle_server_count && \
    cd - >/dev/null

    echo "===$dir_name config change done!==="
}

update_version_server_config()
{
    local dir_name=$1
    local db_name=$2
    local server_no=$3
    local host_ip=$4
    local battle_server_count=$5
    local platform_id=$6
    local server_id=$7
    local debug=$8

    cp config_template/server_config.template.xml \
        config_files/$dir_name/server_config.xml
    cp config_template/slave_server_nginx.template.conf \
        config_files/$dir_name/slave_server_nginx.conf
    cp config_template/slave_server_phpfpm.template.conf \
        config_files/$dir_name/slave_server_phpfpm.conf
    cp config_template/EnjoymiPlatformConfig.template.php \
        config_files/$dir_name/EnjoymiPlatformConfig.php
    cp config_template/XYPlatformConfig.template.php \
        config_files/$dir_name/XYPlatformConfig.php
    cp config_template/PapaPlatformConfig.template.php \
        config_files/$dir_name/PapaPlatformConfig.php

    config_template/server_config.replace.sh \
        config_files/$dir_name/server_config.xml \
        $db_name $server_no $host_ip $battle_server_count
    config_template/slave_server_nginx.replace.sh \
        config_files/$dir_name/slave_server_nginx.conf \
        $server_no

    sed -i 's|^<id.*|<id platform_id="'$platform_id'" server_id="'$server_id'"/>|g' \
        config_files/$dir_name/server_config.xml

    if [ $debug == 'N' ]
    then
        sed -i -e 's/enable_gm_cmd="1"/enable_gm_cmd="0"/g' \
               -e 's/auto_create_account="1"/auto_create_account="0"/g' \
               -e 's/version_check="0"/version_check="1"/g' \
        config_files/$dir_name/server_config.xml
    fi

    echo "===$dir_name config change done!==="
}

# 221 & 224
#                  username    db_name          sever_no host_ip        map_ip          battle_server_count
update_user_config buaofeng    sgzj2_buaofeng   14       192.168.0.221  192.168.100.233 1
#                  chenhaikui  sgzj_chk         15       192.168.0.221  192.168.100.233 1
update_user_config yaoguicheng sgzj_yaoguicheng 16       192.168.0.221  192.168.100.233 1
#                  shaofei     sgzj_dev         17       192.168.0.221  192.168.100.233 1
update_user_config jinshaoqing sgzj_jsq         19       192.168.0.221  192.168.100.233 1
#                  chenhaikui  sgzj_dev         20       192.168.0.226  192.168.100.233 1
update_user_config fengpanpan  sgzj_fpp         22       192.168.0.221  192.168.100.233 1
update_user_config yumenglong  sgzj_yumenglong  23       192.168.0.221  192.168.100.233 1
update_user_config lulihua     sgzj_lulihua     24       192.168.0.221  192.168.100.233 1
update_user_config wanghaitao  sgzj_wht         25       192.168.0.221  192.168.100.233 1
#                  wangchong   sgzj_wc          30       192.168.0.221  192.168.100.233 1
#                  yuchunjia   sgzj_ycj         44       192.168.0.224  192.168.100.233 1

# dev server
#                        dirname           db_name     server_no host_ip       map_ip          battle_server_count
update_dev_server_config SGZJ_FAST_SERVER2 sgzj_dev2   11        192.168.0.225 192.168.100.233 1
update_dev_server_config SGZJ_SERVER       sgzj_daily2 12        192.168.0.225 192.168.100.233 1

# update config template 
svn up config_template

# version server
#                            dir_name db_name      server_no host_ip        battle_server_count  platform_id server_id debug_mode
update_version_server_config stable   sgzj2_stable 11        115.159.96.34  1                    3           1         Y
update_version_server_config weekly   sgzj2_weekly 12        115.159.96.34  1                    3           2         Y
update_version_server_config audit    sgzj_audit   13        115.159.96.34  1                    3           3         Y
update_version_server_config walson   sgzj_walson  14        115.159.96.34  1                    3           4         Y
update_version_server_config txcloud  sgzj_txcloud 12        119.29.101.152 8                    3           1         Y

# xy platform server
update_version_server_config xy_1     sgzj_xy_1    21        119.29.101.152 8                   11           1         N
# papa platform server
update_version_server_config papa_1   sgzj_papa_1  31        119.29.101.152 8                   12           1         N
