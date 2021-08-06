FROM alpine
LABEL author="Dviih, dviih@dviih.email" project="MultiVersion/java" release="b2"

ADD ./entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

COPY --from=openjdk:8-jdk-alpine /usr/lib/jvm/java-1.8-openjdk /usr/lib/jvm/java-1.8-openjdk
COPY --from=openjdk:8-jdk-alpine /usr/lib/libstdc++.so.6 /usr/lib/libstdc++.so.6
COPY --from=openjdk:8-jdk-alpine /usr/lib/libgcc_s.so.1 /usr/lib/libgcc_s.so.1
COPY --from=openjdk:8-jdk-alpine /usr/lib/jvm/java-1.8-openjdk/lib/amd64/jli/libjli.so /usr/lib/libjli.so
COPY --from=openjdk:16-jdk-alpine /opt/openjdk-16 /usr/lib/jvm/java-1.16-openjdk

RUN mv /usr/lib/jvm/java-1.8-openjdk/bin/java /usr/lib/jvm/java-1.8-openjdk/bin/java8
RUN mv /usr/lib/jvm/java-1.16-openjdk/bin/java /usr/lib/jvm/java-1.16-openjdk/bin/java16
RUN apk add --update --no-cache bash
RUN adduser --disabled-password --home /home/container container

USER container
ENV  USER=container HOME=/home/container JAVA_HOME=/usr/lib/jvm/java-1.8-openjdk/:/usr/lib/jvm/java-1.16-openjdk/ PATH=/usr/lib/jvm/java-1.8-openjdk/bin:/usr/lib/jvm/java-1.16-openjdk/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

CMD ["/bin/bash","/entrypoint.sh"]