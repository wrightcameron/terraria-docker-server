#!/bin/bash
# Capture Sigterm and send exit command to terraria server before exiting
_term() { 
  echo "Sending exit command to terraria server." 
  screen -S terraria -X stuff "`printf \"exit\r\"`"
  sleep 10
  screen -ls
  echo "Exiting primary process."
}

# Copy over default config settings to persistant volume, then use those instead if they exist
cp -n ${TERRARIA_SERVER_DIR}/config.txt ${TERRARIA_DATA_DIR}
cp -n ${TERRARIA_SERVER_DIR}/banlist.txt ${TERRARIA_DATA_DIR}
mkdir -p ${TERRARIA_DATA_DIR}/worlds
screen -DmS terraria bash -c "${TERRARIA_SERVER_DIR}/TerrariaServer.bin.x86_64 -config ${TERRARIA_DATA_DIR}/config.txt" &
pid=$!

trap _term SIGTERM
# Screen is running detached, stop docker container from exiting
wait $pid
