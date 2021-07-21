#!/bin/bash
#this script should run at (3, 9, 15, 21):30 @ UTC

export JAVA_HOME=/usr/lib/jvm/java-1.8.0-openjdk-amd64
export TZ=UTC


#configs
BASE_DIR="noaa-windy-data path"
YYYYMMDD=$(date +%Y%m%d)
SOURCE_JSON="current-wind-surface-level-gfs-1.0.json"
DEST_DIR="json output path"
DEST_JSON="gfs.json"


#decide folder hh
hour=$(date +%H)

if [ $hour -lt 3 ]; then
  #get yesterday data
  YYYYMMDD=$(date --date='1 days ago' +%Y%m%d)
  HH="18"
elif [ $hour -lt 9 ]; then
  HH="00"
elif [ $hour -lt 15 ]; then
  HH="06"
elif [ $hour -lt 21 ]; then
  HH="12"
else
  HH="18"
fi

echo "--------$(date)---------"
echo "  Get Data Date: "${YYYYMMDD}${HH}

filename="https://nomads.ncep.noaa.gov/cgi-bin/filter_gfs_1p00.pl?file=gfs.t${HH}z.pgrb2.1p00.f000&lev_10_m_above_ground=on&var_UGRD=on&var_VGRD=on&dir=%2Fgfs.${YYYYMMDD}%2F${HH}%2Fatmos"


curl ${filename} -o ${BASE_DIR}/gfs.t00z.pgrb2.1p00.f000 > /dev/null 2>&1

echo "  Convert grib to json..."
${BASE_DIR}/grib2json/grib2json-0.8.0-SNAPSHOT/bin/grib2json -d -n -o ${BASE_DIR}/${SOURCE_JSON} ${BASE_DIR}/gfs.t00z.pgrb2.1p00.f000 > /dev/null 2>&1

echo "  Minify JSON using nodejs"
node ${BASE_DIR}/jsonMinify/index.js ${BASE_DIR}/${SOURCE_JSON} ${DEST_DIR}/${DEST_JSON} > /dev/null 2>&1

#echo "  Push to git"
#cd ${GIT_DIR}
#echo $(pwd)
#git pull --no-commit
#git add ${DEST_JSON}
#git commit -m "update gfs"
#git push

echo "-------end process-------"
