#! /bin/ash
cd /home/container
wget -q https://multiversion.dviih.software/md5sums.txt -O md5sums.txt
echo "MultiVersion | dviih.technology/multiversion"
# Smart V2
sed -i "s/${D_VARIANT,,}-$D_MINECRAFT_VERSION.jar/$SERVER_JARFILE/g" /home/container/md5sums.txt
if [[ ! $(md5sum -c md5sums.txt 2>/dev/null | grep OK$ | awk '{print $2}') == "OK" ]]; then
  wget -q https://multiversion.dviih.software/${D_VARIANT,,}-$D_MINECRAFT_VERSION.jar -O $SERVER_JARFILE
fi
if [ "$D_MINECRAFT_VERSION" \> "1.16" ]; then
  java16 -jar $SERVER_JARFILE -Xms64M -Xmx${SERVER_MEMORY}M
else
  java8 -jar $SERVER_JARFILE -Xms64M -Xmx${SERVER_MEMORY}M
fi