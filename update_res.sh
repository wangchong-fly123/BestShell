#!/bin/bash

function update_code()
{
    svn up
}

function update_res()
{
    cd settings/gamedata/tbdata
    svn up
    cd ../../..
}

function update_all()
{
    update_code
    update_res
}

case $1 in  
    all) update_all ;;  
    code) update_code ;;  
    res) update_res ;;  
    *) echo "$0 [all | code | res]" ;;
esac
