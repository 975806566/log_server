if [ $# -ne 4 ]
then
  echo "*****Input the necessary parameters:  local_ip cookie mysql_host mysql_passwd"
  echo "*****Call the script like: sh auto_config.sh local_ip def_cookie mysql_host mysql_passwd"
  exit 1
fi

local_ip=$1
cookie=$2
host=$3
passwd=$4

cp -f /opt/etcloud/log_server/etc/vm.args.in /opt/etcloud/log_server/etc/vm.args
cp -f /opt/etcloud/log_server/etc/sys.config.in /opt/etcloud/log_server/etc/sys.config


sed -i "/emqttd/s/[0-9]\{1,3\}\(\.[0-9]\{1,3\}\)\{3\}/$local_ip/g" /opt/etcloud/log_server/etc/sys.config
sed -i "/host/s/[0-9]\{1,3\}\(\.[0-9]\{1,3\}\)\{3\}/$host/g" /opt/etcloud/log_server/etc/sys.config
sed -i "/password/s/123456/$passwd/g" /opt/etcloud/log_server/etc/sys.config
sed -i "/setcookie/s/def_cookie/$cookie/g" /opt/etcloud/log_server/etc/vm.args
exit 0