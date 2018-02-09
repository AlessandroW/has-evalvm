#!/bin/bash

log_output_dir=$(pwd)"/logs/"

#start server
killall python
sleep 2s
> server.log
python -m SimpleHTTPServer &> server.log &
STATUS=0
while [ $STATUS -eq 0 ]; do
    STATUS=$(pgrep python | wc -l)
    sleep 1s
done

bw=$1;
cvar=$2;
init=$3;
p=$4;
reps=$5; 
enc_type=$6; #specify if variable or fixed
vid_id=$7; #name of video, eg bbb
duration=$8
heuristic=$9

cd has-evalvm/shaping
sudo ./setupShaper.sh
echo $bw > value
sudo ./rate.sh
cd ../..

direct=$log_output_dir

std=$(echo $cvar*$bw | bc)
bwparam=$bw","${std%.*}
counter=1
while [ $counter -le $reps ]; do
    logdir_tapas="$direct/player_${bw}_parkour_${heuristic}"
    python tapas/play.py -u http://127.0.0.1:8000/has-evalvm/vids/Parkour/m3u8s/f08e80da-bf1d-4e3d-8899-f0f6155f6efa.m3u8 -m nodec -i $init -b $bwparam -p 40 -a $heuristic -l $logdir_tapas

    sleep 1s
    echo "completed $cvar, $bw, $counter, $vid_id, $enc_type, $duration"
    counter=$((counter + 1))
done
