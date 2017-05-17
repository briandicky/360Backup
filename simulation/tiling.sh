#!/bin/bash
#   Program:
#       This program divides the images into grid of tiles.
#   Author:
#       Wen-Chih, MosQuito, Lo
#   Date:
#       2017.3.3

PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

HEAD=$PWD
echo -e "\nCurrent working directory is $HEAD"
echo "."
sleep 1
echo "."
sleep 1

myfiles=($HEAD/equir/*.png)

echo -e "\nNow we have the images below, and prepare to tile them..."
echo "------------------------------------------------"
for file in "${myfiles[@]}"; do
    echo "$file"
done
echo "------------------------------------------------"
echo "."
sleep 1
echo "."
sleep 1


mkdir tiled_images 2> /dev/null
cd tiled_images
mkdir png_192 2> /dev/null
mkdir png_240 2> /dev/null
mkdir png_320 2> /dev/null

echo "--------start to tile image---------"
echo -e "The size of tiled images is 192x192 now...\n"
cd png_192
declare -i width=192
declare -i height=192
crop_arg=${width}x$height

for file in "${myfiles[@]}"; do
    ori_name=`basename "$file"`
    convert -crop $crop_arg $file ${ori_name%%.*}_%d.png
    echo "Tile: $file done."
done

echo -e "The size of tiled images is 240x240 now...\n"
cd ../png_240
declare -i width=240
declare -i height=240
crop_arg=${width}x$height

for file in "${myfiles[@]}"; do
    ori_name=`basename "$file"`
    convert -crop $crop_arg $file ${ori_name%%.*}_%d.png
    echo "Tile: $file done."
done

echo -e "The size of tiled images is 320x320 now...\n"
cd ../png_320
declare -i width=320
declare -i height=320
crop_arg=${width}x$height

for file in "${myfiles[@]}"; do
    ori_name=`basename "$file"`
    convert -crop $crop_arg $file ${ori_name%%.*}_%d.png
    echo "Tile: $file done."
done
echo "------------end of tiling-------------"
echo "."
sleep 1
echo "."
sleep 1


cd ..
mkdir yuv_192 2> /dev/null
mkdir yuv_240 2> /dev/null
mkdir yuv_320 2> /dev/null

echo "--------start to convert png 2 yuv---------"
echo -e "Convert 192x192 png to 192x192 yuv now..."
cd yuv_192
allpng=($HEAD/tiled_images/png_192/*.png)

for png in "${allpng[@]}"; do
    png_name=`basename "$png"`
    ffmpeg -i $png -pix_fmt yuv420p ${png_name%%.*}.yuv 2> /dev/null
    echo "Convert: $png done."
done

echo -e "Convert 240x240 png to 240x240 yuv now..."
cd ../yuv_240
allpng=($HEAD/tiled_images/png_240/*.png)
for png in "${allpng[@]}"; do
    png_name=`basename "$png"`
    ffmpeg -i $png -pix_fmt yuv420p ${png_name%%.*}.yuv 2> /dev/null
    echo "Convert: $png done."
done

echo -e "Convert 320x320 png to 240x240 yuv now..."
cd ../yuv_320
allpng=($HEAD/tiled_images/png_320/*.png)
for png in "${allpng[@]}"; do
    png_name=`basename "$png"`
    ffmpeg -i $png -pix_fmt yuv420p ${png_name%%.*}.yuv 2> /dev/null
    echo "Convert: $png done."
done
echo "------------end of converting-------------"
echo "."
sleep 1
echo "."
sleep 1


cd ..
mkdir concat_192 2> /dev/null
mkdir concat_240 2> /dev/null
mkdir concat_320 2> /dev/null

echo "--------start to concat multiple yuv to single yuv---------"
cd concat_192
seg_length=(1)
declare -i seg_index=60
tile_size=(192)
tiles_num=$(($((3840/$tile_size))*$((1920/$tile_size))))

yuv=($HEAD/tiled_images/png_192/*.yuv)
yuv_name=${yuv[0]%%0*}

for i in $tile_size[@]; do
    for j in $seg_length[@]; do
        for k in $(seq 0 $(($seg_index-1))); do
            for m in $(seq 0 $(($tiles_num-1))); do
                stf=$(($k*30))
                edf=$((($k+1)*30))
                for l in $(seq $stf $(($edf-1))); do
                    printf -v frame "%05d" $l
                    cat ${HEAD}/tiled_images/${yuv_name}${frame}_$m.yuv >> ${yuv_name}_$i_$j_$k_$m.yuv_
                done
            done
        done
    done
done
echo "------------end of concating-------------"


cd ..
mkdir comp_192 2> /dev/null
mkdir comp_240 2> /dev/null
mkdir comp_320 2> /dev/null

echo "--------start to compress yuv to .265---------"
cd comp_192

allyuv=($HEAD/concat_192/*.yuv)

for comp in "${allyuv[@]}"; do
    x265_name=`basename "$comp"`
    x265 $comp --input-res $crop_arg --fps 30 --qp 28 -r ${x265_name%%.*}.yuv -o ${x265_name%%.*}.265 2> /dev/null
    echo "Compress: $x265_name done."
done
echo -e "------------end of compressing-------------\n"
