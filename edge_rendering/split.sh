#!/bin/bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin:/ssd/bin
export PATH

video=(game)

allmp4=($PWD/*.mp4)
name=`basename "$allmp4"`

declare -i time=0
declare -i seg=4

#ffmpeg -ss 00:00:00 -i game_equir.mp4 -t 00:00:04 game_equir_1.mp4

for i in $(seq 1 15); do 
    echo $name  
    echo "ffmpeg -s 3840x1920 -r 30 -ss ${time} -i $name -t ${seg} game_equir_${i}.mp4"
    echo ""
    ffmpeg -r 30 -ss ${time} -i $name -t ${seg} game_equir_${i}.mp4
    time=$((time+4))
done
