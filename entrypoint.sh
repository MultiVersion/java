#! /bin/bash
cd /home/container
if [[ -z $D_DISABLE_SMART ]]; then
  wget --no-check-certificate -q https://multiversion.dviih.software/md5sums.txt -O md5sums.txt
  sed -i "s/${D_MINECRAFT_VARIANT,,}-$D_MINECRAFT_VERSION.jar/$D_FILE/g" /home/container/md5sums.txt
fi

echo "MultiVersion 21.09 | github.com/MultiVersion"

# Check if the server is using latest tag
if [[ ${D_MINECRAFT_VARIANT,,} == "latest" ]]; then
  echo "You're using LATEST tag, that means your server will be always updated."
fi

# | Check if everything is okay
if [[ -z $D_MINECRAFT_VERSION || -z $D_MINECRAFT_VARIANT ]]; then
  echo "You need to put what you want in startup tab!"
  exit 1
fi
# | Module Smart
if [[ -z "$D_DISABLE_SMART" && ! $(md5sum -c md5sums.txt 2>/dev/null | grep OK$ | awk '{print $2}') == "OK" ]]; then
  wget --no-check-certificate -q https://multiversion.dviih.software/${D_MINECRAFT_VARIANT,,}-${D_MINECRAFT_VERSION}.jar -O $D_FILE
fi
# | Server Startup
echo "eula=true" > eula.txt # Auto eula
if [[ "$(echo "$D_MINECRAFT_VERSION" | cut -d "." -f 2)" -ge "$(echo "1.17" | cut -d "." -f 2)" || ${D_MINECRAFT_VERSION,,} == "latest" ]]; then
  java16 -version
  java16 -Xms64M -Xmx${SERVER_MEMORY}M -jar $D_FILE
  exit 1
else
  java8 -version
  java8 -Xms64M -Xmx${SERVER_MEMORY}M -jar $D_FILE
  exit 1
fi
exit 1
