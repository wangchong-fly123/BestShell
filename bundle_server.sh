#!/bin/bash

build_dir=/home/jenkins/workspace/SGZJ_SERVER/BUILD

if [ $# -ne 2 ]
then
    echo "`basename $0` <server_target> <svn_version>"
    exit 1
fi

server_target=$1
svn_version=$2

src_dir=$build_dir/$svn_version
dest_dir=packages/sgzj2_${server_target}_${svn_version}
config_dir=config_files/$server_target
template_dir=template_files

if [ ! -d $config_dir ]
then
    echo "server target \`$server_target\` is invalid"
    exit 1
fi

if [ ! -d $src_dir ]
then
    echo "$src_dir not found, check svn version is correct"
    exit 1
fi

mkdir -p $dest_dir
if [ $? -ne 0 ]; then exit 1; fi
mkdir -p $dest_dir/bin
if [ $? -ne 0 ]; then exit 1; fi
mkdir -p $dest_dir/bin/log
if [ $? -ne 0 ]; then exit 1; fi
mkdir -p $dest_dir/bin/actionlog
if [ $? -ne 0 ]; then exit 1; fi
mkdir -p $dest_dir/bin/actiondb
if [ $? -ne 0 ]; then exit 1; fi
mkdir -p $dest_dir/bin/tmp
if [ $? -ne 0 ]; then exit 1; fi
mkdir -p $dest_dir/settings/sql
if [ $? -ne 0 ]; then exit 1; fi
mkdir -p $dest_dir/settings/sql/patch
if [ $? -ne 0 ]; then exit 1; fi
mkdir -p $dest_dir/settings/gamedata
if [ $? -ne 0 ]; then exit 1; fi
mkdir -p $dest_dir/settings/platform
if [ $? -ne 0 ]; then exit 1; fi

# copy files
cp $src_dir/bin/sgzj-battleserver $dest_dir/bin/sgzj-battleserver-${server_target}
cp $src_dir/bin/sgzj-worldserver  $dest_dir/bin/sgzj-worldserver-${server_target}
cp $src_dir/bin/sgzj-socialserver $dest_dir/bin/sgzj-socialserver-${server_target}
cp $src_dir/bin/sgzj-scheduleserver $dest_dir/bin/sgzj-scheduleserver-${server_target}
cp $src_dir/bin/dbeditor $dest_dir/bin/dbeditor
cp -r $src_dir/bin/sgzj-slaveserver $dest_dir/bin/
cp -r $src_dir/bin/schedule $dest_dir/bin/

# copy scripts
cp $src_dir/bin/*.sh $dest_dir/bin/
cp $src_dir/bin/*.init $dest_dir/bin/
sed -ri "s/^desc=sgzj-battleserver/desc=sgzj-battleserver-${server_target}/" \
    $dest_dir/bin/battleserver.init

sed -ri "s/^desc=sgzj-worldserver/desc=sgzj-worldserver-${server_target}/" \
    $dest_dir/bin/worldserver.init

sed -ri "s/^desc=sgzj-socialserver/desc=sgzj-socialserver-${server_target}/" \
    $dest_dir/bin/socialserver.init
sed -ri "s/^desc=sgzj-scheduleserver/desc=sgzj-scheduleserver-${server_target}/" \
    $dest_dir/bin/scheduleserver.init

#copy tables
cp -r $src_dir/settings/gamedata/tbdata $dest_dir/settings/gamedata/
cp -r $src_dir/settings/*.txt $dest_dir/settings/
cp -r $src_dir/settings/fastcgi_php.conf $dest_dir/settings/

#copy sql
cp $src_dir/settings/sql/*.sql $dest_dir/settings/sql
cp $src_dir/settings/sql/patch/*.sql $dest_dir/settings/sql/patch

#copy config
cp $config_dir/server_config.xml $dest_dir/settings
cp $config_dir/slave_server_nginx.conf $dest_dir/settings
cp $config_dir/slave_server_phpfpm.conf $dest_dir/settings
cp $config_dir/EnjoymiPlatformConfig.php $dest_dir/settings/platform
cp $config_dir/XYPlatformConfig.php $dest_dir/settings/platform

# chmod
chmod 775 $dest_dir/bin/sgzj-*-${server_target} $dest_dir/bin/*.init $dest_dir/bin/*.sh
chmod 644 $dest_dir/bin/recreate_gamedb.sh

# tar files
cd packages
tar -zcvf sgzj2_${server_target}_${svn_version}.tar.gz sgzj2_${server_target}_${svn_version}/
rm -rf sgzj2_${server_target}_${svn_version}
