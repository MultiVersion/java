#! /bin/bash
cd /home/container
wget -q https://multiversion.dviih.software/md5sums.txt -O md5sums.txt
sed -i "s/${D_MINECRAFT_VARIANT,,}-$D_MINECRAFT_VERSION.jar/$SERVER_JARFILE/g" /home/container/md5sums.txt
echo "MultiVersion 21.08 LTS | github.com/MultiVersion"

# | Check if everything is okay
if [[ -z $D_MINECRAFT_VERSION || -z $D_MINECRAFT_VARIANT ]]; then
  echo "You need to put what you want in startup tab!"
  exit 1
fi

# | Module Smart
if [[ -z "$D_DISABLE_SMART" && ! $(md5sum -c md5sums.txt 2>/dev/null | grep OK$ | awk '{print $2}') == "OK" ]]; then
  wget -q https://multiversion.dviih.software/${D_MINECRAFT_VARIANT,,}-${D_MINECRAFT_VERSION}.jar -O $D_FILE
fi
if [[ "$(echo "$D_MINECRAFT_VERSION" | cut -d "." -f 2)" -ge "$(echo "1.17" | cut -d "." -f 2)" ]]; then
  java16 -version
  java16 -Xms64M -Xmx${SERVER_MEMORY}M -jar $D_FILE
  exit 1
else
  java8 -version
  java8 -Xms64M -Xmx${SERVER_MEMORY}M -jar $D_FILE
  exit 1
fi
