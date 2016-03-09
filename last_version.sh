#!/bin/bash


last_version()
{
    local user_name=$1
    local host_ip=$2
    base_dir=/home/jenkins/workspace/SGZJ_FAST_SERVER2/BUILD/

    ssh $user_name@$host_ip "

    cd $base_dir
    ls -lrt | tail -n 10
    "
}

last_version     jenkins     192.168.0.225
