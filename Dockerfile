FROM alpine
LABEL org.opencontainers.image.source="https://github.com/MultiVersion/java" org.opencontainers.image.source="https://dviih.technology/multiversion" org.opencontainers.image.version="PreLTS" org.opencontainers.image.revision="2108-1" org.opencontainers.image.authors="Dviih" org.opencontainers.image.licenses="unlicense.org"

ADD ./entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

RUN echo "https://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories && \ 
  apk add --no-cache openjdk8 openjdk16 bash && \
  mv /usr/lib/jvm/java-1.8-openjdk/bin/java /usr/lib/jvm/java-1.8-openjdk/bin/java8 && \ 
  mv /usr/lib/jvm/java-16-openjdk/bin/java /usr/lib/jvm/java-16-openjdk/bin/java16

RUN adduser --disabled-password --home /home/container container
USER container
ENV  USER=container HOME=/home/container JAVA_HOME=/usr/lib/jvm/java-1.8-openjdk/:/usr/lib/jvm/java-16-openjdk/ PATH=/usr/lib/jvm/java-1.8-openjdk/bin:/usr/lib/jvm/java-16-openjdk/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

CMD ["/bin/bash","/entrypoint.sh"]