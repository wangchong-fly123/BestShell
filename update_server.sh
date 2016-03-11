#!/bin/bash

bin_dir=/home/yuchunjia/workspace/bin
settings_dir=/home/yuchunjia/workspace/settings
dest_user=yuchunjia
dest_ip=192.168.0.224
version=$1

if [ ! "$version" ]
then
    echo "usage: `basename $0` <version>"
    exit 1
fi

update_server()
{
    local user_name=$1
    local host_ip=$2
    local base_dir=/home/jenkins/workspace/SGZJ_FAST_SERVER2/BUILD/$3
    

    echo "=========================server update begin!==============="

    ssh $user_name@$host_ip "


    scp -r $base_dir/settings/gamedata  	    $dest_user@$dest_ip:$settings_dir
    scp -r $base_dir/settings/sql       	    $dest_user@$dest_ip:$settings_dir
    scp -r $base_dir/settings/platform  	    $dest_user@$dest_ip:$settings_dir

    scp -r $base_dir/bin/schedule       	    $dest_user@$dest_ip:$bin_dir
    scp -r $base_dir/bin/sgzj-slaveserver           $dest_user@$dest_ip:$bin_dir
    scp -r $base_dir/bin/tmp                        $dest_user@$dest_ip:$bin_dir

    scp -r $base_dir/bin/*.sh           	    $dest_user@$dest_ip:$bin_dir
    scp -r $base_dir/bin/*.init                     $dest_user@$dest_ip:$bin_dir
    scp -r $base_dir/bin/*.zip                      $dest_user@$dest_ip:$bin_dir

    scp -r $base_dir/bin/dbeditor                   $dest_user@$dest_ip:$bin_dir
    scp -r $base_dir/bin/sgzj-*server               $dest_user@$dest_ip:$bin_dir
    "

    echo "=========================server update done!==============="
}

stop_server()
{
    echo "=========================server stop begin!==============="
    cd $bin_dir;
    ./stop.sh
    echo "=========================server stop done!==============="
}

start_server()
{
    echo "=========================server start begin!==============="
    cd $bin_dir;
    ./start.sh
    echo "=========================server start done!==============="
}


stop_server

update_server     jenkins     192.168.0.225	$version

start_server
