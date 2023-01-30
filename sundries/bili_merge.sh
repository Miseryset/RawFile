if [ ! -e ${START_DIR}/kr-script/ffmpeg ]; then
  wget -O kr-script/ffmpeg.zip https://raw.githubusercontent.com/Miseryset/RawFile/main/sundries/ffmpeg.zip
  if [ -f ${START_DIR}/kr-script/ffmpeg.zip ] ; then
    unzip -o "${START_DIR}/kr-script/ffmpeg.zip" "ffmpeg/*" -d "${START_DIR}/kr-script" >/dev/null 2>&1
    chmod -R 777 "${START_DIR}/kr-script/ffmpeg"
  else
    echo "下载错误"
    exit 1
  fi
fi

export PATH=${PATH}:"${START_DIR}/kr-script/ffmpeg"
export LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:"${START_DIR}/kr-script/ffmpeg/libs"

#bili_down="/sdcard/Android/data/tv.danmaku.bili/download"
#output_dir="/sdcard/Document"
bili_down="${_bili_down}"
output_dir="${_output_dir}"

for scan in `ls ${bili_down}` ; do
  json=`find "${bili_down}/${scan}" -type f | grep "entry.json"`
  title=`jq '.title' "${json}" | tr -d \"`
  owner_name=`jq '.owner_name' "${json}" | tr -d \"`
  
  if [ -f "${output_dir}/${owner_name}_${title}_${scan}.mp4" ] ; then
    echo "${output_dir}/${owner_name}_${title}_${scan}.mp4 已存在，跳过"
  else
    mkdir -p "${output_dir}/tmp"
    for tt in "audio" "video" ; do
      ff=`find "${bili_down}/${scan}" -type f | grep "${tt}.m4s"`
      cpg -rg "${ff}" "${output_dir}/tmp"
    done
    ffmpeg -i "${output_dir}/tmp/video.m4s" -i "${output_dir}/tmp/audio.m4s" -vcodec copy -acodec copy "${output_dir}/${owner_name}_${title}_${scan}.mp4"
    rm -r "${output_dir}/tmp"
  fi
  
done
