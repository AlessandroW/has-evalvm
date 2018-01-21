#!/bin/bash

#browser_log_dir="/home/valli/.config/chromium/chrome_debug.log"
#browser_log_empty_dir="/home/valli/.config/chromium/chrome_debug_empty.log"
#log_output_dir="/home/valli/workspace/HASDocker/logs/BBB/"
log_output_dir=$(pwd)"/logs/"

#start server
killall python
sleep 2s
> server.log
python -m SimpleHTTPServer &> server.log &
STATUS=0
while [ $STATUS -eq 0 ]; do
#    echo $STATUS
    STATUS=$(pgrep python | wc -l)
    sleep 1s
done

#current_dir=$PWD;
#cd ../..;
#reps=20
trace=$1;
init=$2;
p=$3;
reps=$4; 

#for cvar in 0.0 0.1 0.2 0.4; do
#for bw in 300 400 500 600 700 800 900; do
#for bw in 600 700 800 900 1000 1100 1200; do
	sudo has-evalvm/shaping/setupShaper.sh	

	screen -dmS trace has-evalvm/shaping/trace_loop.sh has-evalvm/shaping/trace_scripts/report_"$trace".sh

	#for trace in "$traces_dir"/report_*.sh ; do
		#file=$(basename "$bw" kbps)
		#name=${file%.*}
		#cut=${name#report_*}
		direct=$log_output_dir
		mkdir $direct
for p in 5 10 40; do
		counter=1
		while [ $counter -le $reps ]; do
			#> $browser_log_dir
			#output=$direct/"$bw"kbit_"$counter".log
	
#			chromium-browser --disk-cache-dir=/dev/null --mute-audio --enable-logging --log-level=0 http://127.0.0.1:8000/test.html &
			python tapas/play.py -u http://127.0.0.1:8000/has-evalvm/vids/Parkour/m3u8s/f08e80da-bf1d-4e3d-8899-f0f6155f6efa.m3u8 -m nodec -i $init -p $p > player.log
#			python tapas-master/play.py -u http://localhost:8000/vids/BBB/playlist.m3u8 -m nodec -b $bwparam > player.log

#		      cp server.log "$direct"/server_"$bw"kbit_cv"$cvar"_init"$3"_"$counter".log	
		      cp player.log "$direct"/player_"$trace"_init"$init"_p"$p"_"$counter".log

#			pgrep trace_loop | xargs kill
#			pgrep report_* | xargs kill
#			killall python			

			sleep 1s
			echo "completed "$trace","$counter
			counter=$((counter + 1))
		done
#	done
#done

tar czf player_"$trace"_init"$init"_p"$p".tar.gz logs/player_"$trace"_init"$init"_p"$p"*.log
scp -o StrictHostKeyChecking=no player_"$trace"_init"$init"_p"$p".tar.gz valli@132.187.12.137:workspace/HASDocker/
done
killall trace_loop.sh
