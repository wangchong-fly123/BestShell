#!/bin/bash
in_file=$1
out_file=$2
log_type=$3
nick_name=$4
#way_type=$5
#item_id=$6
#change_value=$7
#new_value=$8
usage()
{
    printf "usage: $0 [in_file out_file log_type nick_name]\n"
    exit 1
}
if [ ! -f "$in_file" ];
then
    usage
fi

parse_item()
{
    grep ITEM $in_file |grep $nick_name | grep -v ITEMOVERFLOW | awk -F\| '{print strftime("%F %T",$2)"\t"$3"\t"$4"\t"$5"\t"$7"\t"$8"\t"$9}' >> $out_file
}

parse_equip()
{
    grep EQUIP $in_file | grep -v ITEMOVERFLOW | awk -F\| '{print strftime("%F %T",$2)"\t"$3"\t"$4"\t"$5"\t"$7"\t"$8"\t"$9}' >> $out_file
}

parse_res()
{
    grep RES $in_file | awk -F\| '{print strftime("%F %T",$2)"\t"$3"\t"$4"\t"$5"\t"$7"\t"$8"\t"$9}' >> $out_file
}

parse_copy()
{
    grep COPY $in_file | awk -F\| '{print strftime("%F %T",$2)"\t"$4"\t"$6"\t"$7"\t"$8"\t"$9"\t"$10"\t"$11"\t"$12"\t"$13"\t"$14}' >> $out_file
}

parse_dynamic()
{
    grep DYNAMIC $in_file | awk -F\| '{print strftime("%F %T",$2)"\t"$4"\t"$6"\t"$7"\t"$8"\t"$9"\t"$10"\t"$11"\t"$12"\t"$13"\t"$14}' >> $out_file
}

parse_login()
{
    grep -E 'LOGIN|LOGOUT' $in_file | awk -F\| '{print strftime("%F %T",$2)"\t"$4"\t"$5"\t"$6"\t"$7"\t"$8"\t"$9"\t"$10"\t"$11"\t"$12}' >> $out_file
}

case "$log_type" in
    ITEM)
        parse_item
        ;;
    RES)
        parse_res
        ;;
    EQUIP)
        parse_equip
        ;;
    COPY)
        parse_copy
        ;;
    DYNAMIC)
        parse_dynamic
        ;;
    LOGIN)
        parse_login
        ;;
    *)
        usage
        ;;
esac

