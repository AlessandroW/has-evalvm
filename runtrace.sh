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


trace=$1;
cvar=$2;
init=$3;
p=$4;
reps=$5; 
enc_type=$6; #specify if variable or fixed
vid_id=$7; #name of video, eg bbb
duration=$8
heuristic=$9

sudo has-evalvm/shaping/setupShaper.sh	

screen -dmS trace has-evalvm/shaping/trace_loop.sh has-evalvm/shaping/trace_scripts/report_"$trace".sh
direct=$log_output_dir
mkdir $direct

counter=1
while [ $counter -le $reps ]; do
	logdir_tapas="$direct/player_${trace}_${counter}_${vid_id}_${enc_type}_${duration}_${heuristic}"
	python tapas/play.py -u http://127.0.0.1:8000/videos/streaming_vids/${vid_id}_${enc_type}_${duration}.m3u8 -m nodec -i $init -p 40 -a $heuristic -l $logdir_tapas
	#cp player.log "$direct"/player_"$trace"_init"$init"_p"$p"_"$counter".log
	sleep 1s
	echo "completed "$trace","$counter
	counter=$((counter + 1))
	
done


killall trace_loop.sh
