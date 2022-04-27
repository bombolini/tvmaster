#!/bin/sh
apt-get update
apt-get -y install tstools pkg-config build-essential libssl-dev git liburiparser-dev libcurl4-openssl-dev unzip screen curl mbuffer gettext dvb-apps libev-dev vlc vlc-nox

# DVBLast
rm -rf dvblast
git clone https://github.com/gfto/dvblast.git
cd dvblast
git clone https://github.com/gfto/bitstream.git
cd bitstream
sudo make install
cd ..
make
sudo make install
cd ..
rm -rf dvblast

# Opencaster
apt-get -y install python-dev
rm -rf opencaster_3.2.2+dfsg.orig.tar.gz
wget http://ftp.de.debian.org/debian/pool/main/o/opencaster/opencaster_3.2.2+dfsg.orig.tar.gz
tar -zxvf opencaster_3.2.2+dfsg.orig.tar.gz
cd opencaster-3.2.2
sed -i 's/mpe2sec//g' tools/Makefile
make
make install
cd libs
make install
cd dvbobjects
make install
./setup.py install
cd ../../
cd ..
rm -rf opencaster-3.2.2*

# TSPLAY
git clone https://code.google.com/p/tstools/
cd tstools
make
cp bin/tsplay /bin/tsplay
cd ..
rm -rf tstools

#TVHEADEND
rm -rf tvheadend/
env GIT_SSL_NO_VERIFY=true git clone https://github.com/tvheadend/tvheadend.git
cd tvheadend
./configure --disable-libav --disable-libffmpeg_static --disable-hdhomerun_static
make -j 4
killall tvheadend
sleep 2
killall -9 tvheadend
sleep 1
cd ..
cd ..
/root/tvmaster/script/restart.sh

exit 0
