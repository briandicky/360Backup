PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin:/ssd/bin
export PATH

HEAD=$PWD
video=coaster2

declare -i frame=901
name=$(($frame-1))

rm ${video}_input_${name}.csv ${video}_output_${name}.csv

for p in $(seq -w 1 50); do
    for v in ${video[0]}; do
        cat ${v}_user${p}_orientation.csv | awk 'FNR == 901 {print $1 $8 $9}' >> ${video}_input_${name}.csv
        python $HEAD/trajectory.py ${video}_input_${name}.csv ${video}_output_${name}.csv
    done
done

