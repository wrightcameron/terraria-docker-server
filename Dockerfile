FROM debian:stable-slim as build

ENV TERRARIA_VERSION 1423

RUN apt-get update && apt-get -y install apt-utils wget tmux unzip
RUN wget https://terraria.org/system/dedicated_servers/archives/000/000/046/original/terraria-server-${TERRARIA_VERSION}.zip -O terraria-server.zip
RUN unzip terraria-server.zip -d terraria-server

FROM debian:stable-slim
RUN apt-get update && apt-get -y install tmux screen cron logrotate

ENV TERRARIA_VERSION 1423
ENV TERRARIA_SERVER_DIR /opt/terraria/server
ENV TERRARIA_DATA_DIR /opt/terraria/data

RUN mkdir -p ${TERRARIA_SERVER_DIR} && mkdir -p ${TERRARIA_DATA_DIR}/{worlds,logs}
WORKDIR ${TERRARIA_SERVER_DIR}
COPY --from=build /terraria-server/${TERRARIA_VERSION}/Linux .
COPY ./config.txt ./config.txt
COPY ./startTerraria.sh ./startTerraria.sh
RUN touch ./banlist.txt


RUN groupadd --gid 1001 terraria \
    && useradd -mg terraria --uid 1001 terraria \
    && chown terraria:terraria -R /opt/terraria \
    && chmod +x ./TerrariaServer.bin.x86* ./startTerraria.sh

# Setup log rotate so logs never fill up volume.
COPY ./terrariaLogs /etc/logrotate.d/
RUN chmod 644 /etc/logrotate.d/terrariaLogs \
    && chown root:root /etc/logrotate.d/terrariaLogs

USER terraria
CMD ["./startTerraria.sh"]