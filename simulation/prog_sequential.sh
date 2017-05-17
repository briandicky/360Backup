#!/bin/bash
#   Program:
#       This program divides the images into grid of tiles.
#   Author:
#       Wen-Chih, MosQuito, Lo
#   Date:
#       2017.3.7

PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin:/ssd/bin
export PATH

HEAD=$PWD
echo -e "\nCurrent working directory is $HEAD"
echo "."
sleep 1
echo "."
sleep 1


mkdir tiled_images 2> /dev/null
cd tiled_images
mkdir raw_yuv 2> /dev/null
cd raw_yuv
rm *.yuv

allpng=($HEAD/equir/*.png)

echo -e "\nNow we have the images below, then convert them to yuv..."
echo "------------------------------------------------"
for png in ${allpng[@]}; do
    echo "$png"
    png_name=`basename "$png"`
    ffmpeg -i $png -pix_fmt yuv420p ${png_name%%.*}.yuv 2> /dev/null
    echo "Convert: $png done."
done
echo "------------------------------------------------"
echo "."
sleep 1
echo "."
sleep 1

echo "------------start to concate mutilple yuv to single yuv-------------"
allyuv=(*.yuv)
yuv_name=${allyuv[0]%%0*}

for yuv in ${allyuv[@]}; do
    cat $yuv >> ${yuv_name}1min.yuv
done

echo "Concate: ${yuv_name}1min.yuv done."
echo "------------end of concating-------------"
echo "."
sleep 1
echo "."
sleep 1


source_yuv=($HEAD/tiled_images/raw_yuv/coaster_equir_1min.yuv)

cd ..
mkdir h265_comp 2> /dev/null
cd h265_comp
rm * 2> /dev/null

declare -i tile_size=(192 240 320)
declare -i seg_length=(1 4 10)
declare -i seg_num=(60 15 6)
declare -i x_axis=(10 8 6)
declare -i y_axis=(20 16 12)

rm $HEAD/tiled_images/output.csv
echo "file,size,psnr,ssim,opvq" >> $HEAD/tiled_images/output.csv

for i in ${tile_size[0]}; do #this is tile-size
    for j in ${seg_length[2]}; do #this is seq-length
        for k in $(seq 0 $(($((60/$j))-1))); do #this is seq-index
            for m in $(seq 0 $(($((1920/$i))-1))); do #this is x-index
                for n in $(seq 0 $(($((3840/$i))-1))); do #this is y-index
                    echo "$i" "$j" "$k" "$m" "$n"
                    # tile yuv and concat them
                    ffmpeg -f rawvideo -vcodec rawvideo -s 3840x1920 -r 30 -pix_fmt yuv420p -i $source_yuv -ss $(($j*$k)) -t $j -vf crop=$i:$i:$(($n*$i)):$(($m*$i)) -f rawvideo -vcodec rawvideo -pix_fmt yuv420p -s ${i}x${i} -r 30 coaster_equir_${i}_${j}_${k}_${m}_${n}.yuv 2> /dev/null
                    
                    #encode the yuv file from concatenation
                    x265 coaster_equir_${i}_${j}_${k}_${m}_${n}.yuv --input-res ${i}x${i} --fps 30 --qp 28 -r recon_${i}_${j}_${k}_${m}_${n}.yuv -o coaster_equir_${i}_${j}_${k}_${m}_${n}.265 

                    #rm coaster_equir_${i}_${j}_${k}_${m}_${n}.yuv

                    #calculate the file size and video quality
                    ls -l coaster_equir_${i}_${j}_${k}_${m}_${n}.265  | awk '{ printf $9 }' >> $HEAD/tiled_images/output.csv
                    printf "," >> $HEAD/tiled_images/output.csv

                    ls -l coaster_equir_${i}_${j}_${k}_${m}_${n}.265  | awk '{ printf $5 }' >> $HEAD/tiled_images/output.csv
                    printf "," >> $HEAD/tiled_images/output.csv

                    #openvq, psnr, ssim and pevq
                    ffmpeg -s ${i}x${i} -r 30 -vcodec rawvideo -f rawvideo -pix_fmt yuv420p -i coaster_equir_${i}_${j}_${k}_${m}_${n}.yuv -q:v 0 -r 30 coaster_equir_${i}_${j}_${k}_${m}_${n}.avi
                    ffmpeg -s ${i}x${i} -r 30 -vcodec rawvideo -f rawvideo -pix_fmt yuv420p -i recon_${i}_${j}_${k}_${m}_${n}.yuv -q:v 0 -r 30 recon.avi
                    
                    openvq psnr -t 300 -s coaster_equir_${i}_${j}_${k}_${m}_${n}.avi -p recon.avi | awk 'FNR == 4 {printf $4}' >> $HEAD/tiled_images/output.csv
                    printf "," >> $HEAD/tiled_images/output.csv

                    openvq ssim -t 300 -s coaster_equir_${i}_${j}_${k}_${m}_${n}.avi -p recon.avi | awk 'FNR == 4 {printf $4}' >> $HEAD/tiled_images/output.csv
                    printf "," >> $HEAD/tiled_images/output.csv

                    openvq opvq -t 300 -s coaster_equir_${i}_${j}_${k}_${m}_${n}.avi -p recon.avi | awk 'FNR == 14 {print $3}' >> $HEAD/tiled_images/output.csv
                    
                    #remove all the middle files
                    rm recon.avi
                    rm coaster_equir_${i}_${j}_${k}_${m}_${n}.avi
                    rm coaster_equir_${i}_${j}_${k}_${m}_${n}.yuv
                    rm coaster_equir_${i}_${j}_${k}_${m}_${n}.265
                    rm recon_${i}_${j}_${k}_${m}_${n}.yuv
                done
            done
        done
    done
    #rm $HEAD/tiled_images/h265_comp/*
done

echo "Finished!"
