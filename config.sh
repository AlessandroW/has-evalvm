#!/bin/bash

#bandbreitenlimit in kbps
declare -a bw=(300 400 500 600 700 800 900 1000);
declare -a bwm=(1300 1600 1900 2200 2500 2800 3100 3400);
declare -a bwh=(3700 4000 4300 4600 4900 5000 6000 7000);
#variation der bandbreite
cvar=0

init=0

#anzahl der runs mit der gleichen konfiguration
reps=1

#heuristic 
declare -a heuristics=("conventional" "festive")

for h in "${heuristics[@]}"
do
	for b in "${bwh[@]}"
	do
		echo "_______Running with config " $h $b
		./has-evalvm/run.sh $b $cvar $init 0 $reps 0 0 0 $h
	done
done

