#!/bin/bash

for D in *; do
    if [ -d "${D}" ]; then
    	for f in $D/*; do 
		name=${f//[\/]/_}
		echo "$name"
		mv $f ./$name
	done
    fi
done

