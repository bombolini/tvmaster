#!/bin/sh
# Setup kernel network tuning.
ifconfig lo multicast
ip route add 224.0.0.0/4 dev lo src 127.0.0.1

# Fix dirs.
mkdir /tmp/tvmaster/

kill -9 `ps ax | grep "tvheadend -a 15 --http_port 9981" | grep -v grep | awk '{print $1}'` > /dev/null 2>&1
killall streamer.sh vlc dvblast
killall dvblast tsudpreceive tsudpsend tscbrmuxer
sleep 1
rm -rf /mnt/timeshift
mkdir /mnt/timeshift
/root/tvmaster/bin/tvheadend/build.linux/tvheadend -a 15 --http_port 9981 --htsp_port 9982 --config /root/tvmaster/.hts/tvheadend/ 2> /tmp/tvh.log &
