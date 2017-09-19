#!/bin/bash

PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

tile_size=9x9
tile_qual=medium

#./read_pcap 9x9_high_all.pcap > 9x9_high_all.csv
./read_pcap ${tile_size}_${tile_qual}.pcap > ${tile_size}_${tile_qual}.csv

#python parser2csv.py 9x9_high_all.csv result_9x9_high_all.csv
python parser2csv.py ${tile_size}_${tile_qual}.csv result_${tile_size}_${tile_qual}.csv
