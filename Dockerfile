FROM debian:stable-slim as build

ENV TERRARIA_VERSION 1423

RUN apt-get update && apt-get -y install apt-utils wget tmux unzip
RUN wget https://terraria.org/system/dedicated_servers/archives/000/000/046/original/terraria-server-${TERRARIA_VERSION}.zip -O terraria-server.zip
RUN unzip terraria-server.zip -d terraria-server

FROM debian:stable-slim
RUN apt-get update && apt-get -y install tmux screen

ENV TERRARIA_VERSION 1423
ENV TERRARIA_SERVER_DIR /opt/terraria/server
ENV TERRARIA_DATA_DIR /opt/terraria/data

RUN mkdir -p ${TERRARIA_SERVER_DIR} && mkdir -p ${TERRARIA_DATA_DIR}/worlds
WORKDIR ${TERRARIA_SERVER_DIR}
COPY --from=build /terraria-server/${TERRARIA_VERSION}/Linux .
COPY ./config.txt ./config.txt
RUN touch ./banlist.txt
COPY ./startTerraria.sh ./startTerraria.sh

RUN groupadd --gid 1001 terraria \
    && useradd -mg terraria --uid 1001 terraria
RUN chown terraria:terraria -R /opt/terraria
RUN chmod +x ./TerrariaServer.bin.x86* ./startTerraria.sh

USER terraria
CMD ["./startTerraria.sh"]