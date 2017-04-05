#!/bin/bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin:/ssd/bin
export PATH

HEAD=$PWD
video=(coaster coaster2 diving drive game landscape pacman panel ride sport)
peo=(ashely  boying  chu1     guan      hbfriend  Hsu    Jean      kuo    Liao  maogirl  peiyu  rong   shihsian  suewei  wind  yao      yilin
Aylada  chang   chu2     guanyu    hongjin   huang  jkddsars  Lai    Lin   mindy    PH     sandy  shinyu    Wang    wu    yaogirl  yunikoFan
belkys  cheng   doughwu  guanyuan  hotblood  inin   kaiyuan   Laoda  mao   PC       pu     Scoly  shiya     wc      Yan   yihsian)

# for each person
for p in $(seq 0 49); do
	# for each video
	for v in $(seq 0 9); do
		echo ${peo[$p]} ${video[$v]}
		cd ${peo[$p]}/${video[$v]}_corr_sensor_data
		stf=stf$p[$v]
		echo ${stf}
		#python $HEAD/parsedata.py frame_time.log ${video[$v]} $HEAD/corr 3840 1920 35 60 ${!stf} 30 20 10 $HEAD/ground_truth/${video[$v]}_${peo[$p]}_gt.csv $HEAD/sensor/${video[$v]}_${peo[$p]}_ss.csv
        mv sensor_data.csv $HEAD/${video[$v]}_${peo[$p]}_sensor_data.csv
        mv frame_time.log $HEAD/${video[$v]}_${peo[$p]}_frame_time.log
		cd ../../
	done
done
