function print_customized_hosts(){
  echo "自定义host为："
  echo "${customized_hosts}"
  cp -f "/sdcard/Android/AnyHosts/user_rules" "/sdcard/Android/AnyHosts/user_rules-$(date +%F)_$(date +%T).bak"
  echo "user_rules 已备份"
  echo "${customized_hosts}" | sed "s/ /=/g" >/sdcard/Android/Anyhosts/user_rules
}


while getopts ":ps" signal ; do
  case ${signal} in
    p) #print_existed_hosts
      cat /sdcard/Android/AnyHosts/user_rules | sed "s/=/ /g"
      ;;
    s) #start_update
      print_customized_hosts
      echo "开始更新"
      . "/sdcard/Android/AnyHosts/Start.sh"
      ;;
    ?)
      echo ""
      ;;
  esac
done
