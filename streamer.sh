#!/bin/sh
trap 'kill -9 $PID $PID2 2>/dev/null' EXIT

# Read config files and set vars.
while read -r f1 f2 f3 f4 f5 f6 f7 f8 f9 f10 f11 f12 f13 f14 f15 f16 f17
do
if [ "$1" == "$f2" ]; then echo $1 $f2 1>&2; mcast="$f1"; source="$f3"; channel="$f4"; sdtname="$f2"; pids="$f5"; source2="$f6"; channel2="$f7"; pids2="$f8"; source3="$f9"; channel3="$f10"; pids3="$f11"; source4="$f12"; channel4="$f13"; pids4="$f14"
fi
if [ -z "$source2" ]; then
source2="$f3"; channel2="$f4"; pids2="$f5"
fi
if [ -z "$source3" ]; then
source3="$f3"; channel3="$f4"; pids3="$f5"
fi
if [ -z "$source4" ]; then
source4="$f3"; channel4="$f4"; pids4="$f5"
fi
done < <(cat conf/channel.*.conf | grep -v grep | grep -v "#")

if [ -z "$source" ]; then
echo "Exit didnt find channel in config $1 $f2" 1>&2
sleep 10
exit
fi

while read -r f1 f2 f3 f4 f5 f6 f7
do
if [ "$source" == "$f1" ]; then encoder="$f2"; link1="$f3"; link2="$f4"; link3="$f5"; link4="$f6"
if [ -z "$link2" ]; then link2="$f3"; fi
if [ -z "$link3" ]; then link3="$f3"; fi
if [ -z "$link4" ]; then link4="$f3"; fi
fi
done < <(cat conf/source.conf | grep -v grep | grep -v "#")

while read -r f1 f2 f3 f4 f5 f6 f7
do
if [ "$source2" == "$f1" ]; then encoder2="$f2"; link21="$f3"; link22="$f4"; link23="$f5"; link24="$f6"
if [ -z "$link22" ]; then link22="$f3"; fi
if [ -z "$link23" ]; then link23="$f3"; fi
if [ -z "$link24" ]; then link24="$f3"; fi
fi
done < <(cat conf/source.conf | grep -v grep | grep -v "#")

while read -r f1 f2 f3 f4 f5 f6 f7
do
if [ "$source3" == "$f1" ]; then encoder3="$f2"; link31="$f3"; link32="$f4"; link33="$f5"; link34="$f6"
if [ -z "$link32" ]; then link32="$f3"; fi
if [ -z "$link33" ]; then link33="$f3"; fi
if [ -z "$link34" ]; then link34="$f3"; fi
fi
done < <(cat conf/source.conf | grep -v grep | grep -v "#")

while read -r f1 f2 f3 f4 f5 f6 f7
do
if [ "$source4" == "$f1" ]; then encoder4="$f2"; link41="$f3"; link42="$f4"; link43="$f5"; link44="$f6"
if [ -z "$link42" ]; then link42="$f3"; fi
if [ -z "$link43" ]; then link43="$f3"; fi
if [ -z "$link44" ]; then link44="$f3"; fi
fi
done < <(cat conf/source.conf | grep -v grep | grep -v "#")

# Functions for the type of encoder.
function wget_flu {
echo "Using $1/$2/mpegts?token=$your_flussonic_token_here" 1>&2
wget --auth-no-challenge -t1 -T10 -qO- "$1/$2/mpegts?token=your_flussonic_token_here" &
PID=$!
wait $PID
}

function wget_tvh2 {
wget --no-check-certificate --auth-no-challenge -t1 -T10 -qO- "$1/stream/channelname/$2?profile=pass&mux=pass" &
PID=$!
wait $PID
}

function wget_tvh {
sdtname2=`echo $sdtname | sed 's/&/%26/g' | sed 's/+/%2B/g' | sed 's/_/+/g'`
wget --user-agent="your_user_agent" --auth-no-challenge -t1 -T5 -qO- "http://master:f6J756KJdbbJewng@public_tvh_ip1:9981/stream/channelname/$sdtname2?profile=pass&mux=pass" &
PID=$!
wait $PID
wget --user-agent="your_user_agent" --auth-no-challenge -t1 -T5 -qO- "http://bombolini:fejsrtjejsfe@public_tvh_ip2:9981/stream/channelname/$sdtname2?profile=pass&mux=pass" &
PID=$!
wait $PID
wget --user-agent="your_user_agent" --auth-no-challenge -t1 -T5 -qO- "http://bombolini:fejsrtjejsfe@public_tvh_ip3:9981/stream/channelname/$sdtname2?profile=pass&mux=pass" &
PID=$!
wait $PID
wget --user-agent="your_user_agent" --auth-no-challenge -t1 -T5 -qO- "http://bombolini:fejsrtjejsfe@public_tvh_ip4:9981/stream/channelname/$sdtname2?profile=pass&mux=pass" &
PID=$!
wait $PID
wget --user-agent="your_user_agent" --auth-no-challenge -t1 -T5 -qO- "http://bombolini:fejsrtjejsfe@public_tvh_ip5:9981/stream/channelname/$sdtname2?profile=pass&mux=pass" &
PID=$!
wait $PID
wget --user-agent="your_user_agent" --auth-no-challenge -t1 -T5 -qO- "http://bombolini:fejsrtjejsfe@public_tvh_ip6:9981/stream/channelname/$sdtname2?profile=pass&mux=pass" &
PID=$!
wait $PID
wget --user-agent="your_user_agent" --auth-no-challenge -t1 -T5 -qO- "http://$user:$pass@$tvh_public_ip:$port/stream/channelname/$sdtname2?profile=pass&mux=pass" &
PID=$!
wait $PID
}

function tsplay_tvh {
while read -r f1 f2
do
if [ "$f1" == "$2" ]; then stream_id="$f2"; fi
done < <(curl -s --retry 0 --max-time 2 $1/playlist/channels | sed 's/tvg-id=.*,/,/g' | sed 's/logo=.*,/,/g' | sed 's/?ticket.*//g' | sed ':a;N;$!ba;s/\n/ /g' | sed "s/'//g" | sed 's/ //g' | \
        sed 's/#EXTINF/\n#EXTINF/g' | sed 's/http:/ http:/g' | sed 's/`//g' | sed 's/#EXTINF:-1,//g' | sed 's/http:\/\/.*\/stream\/channelid\///g')
if [ -z "$stream_id" ]; then
link=`echo $1 | sed 's/http.*\@/http:\/\//g'`
echo "NOT FOUND -> $2 on $4 $link" 1>&2
echo "`date` NOT FOUND -> $2 on $4 $1" >> /tmp/notfound
else
link=`echo $1 | sed 's/http.*\@/http:\/\//g'`
echo "Using $4 $link/$stream_id Programid: $3" 1>&2
pid1=`echo $3 | sed 's/\./ /g'`
mcasq=`echo $mcast | sed 's/5501/5500/g'`
wget --auth-no-challenge -t1 -T5 -qO- "$1/stream/channelid/$stream_id?profile=pass&mux=pass" | sudo -u vlc_user cvlc --play-and-exit -I dummy - --ts-out $mcasq > /dev/null 2>&1 &
PID=$!
echo "$mcast@127.0.0.1/udp/tsid=1/newsid=1/srvname=$sdtname 0 $pid1" > /tmp/tvmaster/$sdtname.cfg
/usr/local/bin/dvblast -D @$mcasq/udp -c /tmp/tvmaster/$sdtname.cfg -o 127.0.0.1 -C -N 1 -B tvstream > /tmp/$sdtname.log 2>&1 &
disown
sudo -u vlc_user cvlc --play-and-exit --quiet -I dummy udp://@$mcast :demux=dump :demuxdump-file=- 2> /dev/null &
PID2=$!
disown
wait $PID
kill -9 `ps ax | grep dvblast | grep $mcasq | awk '{print $1}'` > /dev/null 2>&1
kill -9 `ps ax | grep vlc | grep $mcasq | awk '{print $1}'` > /dev/null 2>&1
kill -9 `ps ax | grep vlc | grep $mcast | awk '{print $1}'` > /dev/null 2>&1
fi
stream_id=""
}

function tsplay_tvh2 {
link=`echo $1 | sed 's/http.*\@/http:\/\//g'`
echo "Using $4 $link/$stream_id Programid: $3" 1>&2
pid1=`echo $3 | sed 's/\./ /g'`
mcasq=`echo $mcast | sed 's/5501/5500/g'`
wget --auth-no-challenge -t1 -T5 -qO- "$1/stream/channelname/$2?profile=pass&mux=pass" | sudo -u vlc_user cvlc --play-and-exit -I dummy - --ts-out $mcasq > /dev/null 2>&1 &
PID=$!
echo "$mcast@127.0.0.1/udp/tsid=1/newsid=1/srvname=$sdtname 0 $pid1" > /tmp/tvmaster/$sdtname.cfg
/usr/local/bin/dvblast -D @$mcasq/udp -c /tmp/tvmaster/$sdtname.cfg -o 127.0.0.1 -C -N 1 -B tvstream > /tmp/$sdtname.log 2>&1 &
disown
sudo -u vlc_user cvlc --play-and-exit --quiet -I dummy udp://@$mcast :demux=dump :demuxdump-file=- 2> /dev/null &
PID2=$!
disown
wait $PID
kill -9 `ps ax | grep dvblast | grep $mcasq | awk '{print $1}'` > /dev/null 2>&1
kill -9 `ps ax | grep vlc | grep $mcasq | awk '{print $1}'` > /dev/null 2>&1
kill -9 `ps ax | grep vlc | grep $mcast | awk '{print $1}'` > /dev/null 2>&1
#fi
#stream_id=""
}


function tsplay_tvh_vlc {
while read -r f1 f2
do
if [ "$f1" == "$2" ]; then stream_id="$f2"; fi
done < <(curl -s --retry 0 --max-time 2 $1/playlist/channels | sed 's/tvg-id=.*,/,/g' | sed 's/logo=.*,/,/g' | sed 's/?ticket.*//g' | sed ':a;N;$!ba;s/\n/ /g' | sed "s/'//g" | sed 's/ //g' | \
        sed 's/#EXTINF/\n#EXTINF/g' | sed 's/http:/ http:/g' | sed 's/`//g' | sed 's/#EXTINF:-1,//g' | sed 's/http:\/\/.*\/stream\/channelid\///g')
if [ -z "$stream_id" ]; then
link=`echo $1 | sed 's/http.*\@/http:\/\//g'`
echo "NOT FOUND -> $2 on $4 $link" 1>&2
echo "`date` NOT FOUND -> $2 on $4 $1" >> /tmp/notfound
else
link=`echo $1 | sed 's/http.*\@/http:\/\//g'`
echo "Using $4 $link/$stream_id Programid: $3" 1>&2
pid1=`echo $3 | sed 's/\..*/ /g'`
mcasq=`echo $mcast | sed 's/5501/5500/g'`
wget --auth-no-challenge -t1 -T10 -qO- "$1/stream/channelid/$stream_id?profile=pass&mux=pass" | sudo -u vlc_user cvlc --play-and-exit -I dummy - --ts-out $mcasq > /dev/null 2>&1 &
PID=$!
echo "$mcast@127.0.0.1/udp/tsid=1/newsid=1/srvname=$sdtname 0 $pid1" > /tmp/tvmaster/$sdtname.cfg
/usr/local/bin/dvblast -D @$mcasq/udp -c /tmp/tvmaster/$sdtname.cfg -o 127.0.0.1 -C -N 1 -B tvstream > /dev/null 2>&1 &
disown
sudo -u vlc_user cvlc --play-and-exit --quiet -I dummy udp://@$mcast :demux=dump :demuxdump-file=- 2> /dev/null &
PID2=$!
disown
wait $PID
kill -9 `ps ax | grep dvblast | grep $mcasq | awk '{print $1}'` > /dev/null 2>&1
kill -9 `ps ax | grep vlc | grep $mcasq | awk '{print $1}'` > /dev/null 2>&1
kill -9 `ps ax | grep vlc | grep $mcast | awk '{print $1}'` > /dev/null 2>&1
fi
stream_id=""
}

# Loop Running the encoder.
printf -v var "$encoder $link1 $channel $pids $source
$encoder $link2 $channel $pids $source
$encoder $link3 $channel $pids $source
$encoder $link4 $channel $pids $source
$encoder2 $link21 $channel2 $pids2 $source2
$encoder2 $link22 $channel2 $pids2 $source2
$encoder2 $link23 $channel2 $pids2 $source2
$encoder2 $link24 $channel2 $pids2 $source2
$encoder3 $link31 $channel3 $pids3 $source3
$encoder3 $link32 $channel3 $pids3 $source3
$encoder3 $link33 $channel3 $pids3 $source3
$encoder3 $link34 $channel3 $pids3 $source3
$encoder4 $link41 $channel4 $pids4 $source4
$encoder4 $link42 $channel4 $pids4 $source4
$encoder4 $link43 $channel4 $pids4 $source4
$encoder4 $link44 $channel4 $pids4 $source4"
var2=`echo -e "$var" | awk '!a[$0]++'`

echo "$var2" 1>&2

count=0
while [ "$count" -lt "100" ]
do
count=$((count+1))
while read -r f1 f2 f3 f4 f5 f6
do
$f1 $f2 $f3 $f4 $f5
stream_id=""
done < <(echo -e "$var2")
while read -r f1 f2 f3 f4 f5 f6
do
$f1 $f2 $f3 $f4 $f5
stream_id=""
done < <(echo -e "$var2")
echo "Failed -> $channel restarting in 10 seconds." 1>&2
echo "`date` Failed -> $channel restarting in 5 seconds." >> /tmp/notfound
sleep 5
done
